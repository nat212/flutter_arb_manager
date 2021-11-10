import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_i18n_manager/src/project/token.dart';
import 'package:flutter_i18n_manager/src/project_config/project_config_service.dart';

class ProjectService {
  final ProjectConfigService _config;
  late String _path;
  late List<String> _locales;

  late List<Token> _tokens;
  Token? _trash;
  int? _trashIndex;

  ProjectService(this._config);

  Future<void> initialise(String path) async {
    _path = path;
    Directory.current = path;
    await _config.loadProject(path);
    if (arbDir != null) {
      await _scanLocaleFiles();
      await _loadTokens();
    }
  }

  String get path => _path;
  String? get arbDir => _config.arbDir;
  String? get templateArbFile => _config.templateArbFile;
  String? get outputLocalisationFile => _config.outputLocalisationFile;
  List<Token> get tokens => _tokens;

  Future<void> updateL10nConfig(
      {required String arbDir,
      required String templateArbFile,
      required String outputLocalisationFile}) async {
    if (arbDir != _config.arbDir) {
      _config.setArbDir(arbDir);
    }
    if (templateArbFile != _config.templateArbFile) {
      _config.setTemplateArbFile(templateArbFile);
    }
    if (outputLocalisationFile != _config.outputLocalisationFile) {
      _config.setOutputLocalisationFile(outputLocalisationFile);
    }
  }

  Future<void> saveConfig() async {
    await _config.saveL10nConfig();
    await _scanLocaleFiles();
  }

  Future<void> generateAppLocalisations() async {
    final result =
        await Process.run('flutter', ['gen-l10n'], workingDirectory: _path);
    if (result.exitCode != 0) {
      throw Exception(result.stderr);
    }
  }

  Future<void> _scanLocaleFiles() async {
    final dir = Directory(arbDir!);
    final files = await dir
        .list()
        .map((event) => event)
        .where((event) => event.path.endsWith('.arb'))
        .toList();
    final locales =
        files.map((f) => f.path.split('/').last.split('.')[0]).map((f) {
      final parts = f.split('_');
      if (parts.length > 2) {
        return '${parts[parts.length - 2]}_${parts.last}';
      } else {
        return parts.last;
      }
    });
    _locales = locales.toList();
  }

  Future<void> _loadTokens() async {
    File template = File('$arbDir/$templateArbFile');
    String contents = await template.readAsString();
    final Map<String, dynamic> data = jsonDecode(contents);
    _tokens = [];
    for (final key in data.keys.where((key) => !key.startsWith('@'))) {
      final tokenName = key;
      final tokenValue = data[key];
      if (tokenValue is String) {
        final Map<String, dynamic> metadata = data['@$key'];
        final description = metadata['description'] as String;
        final Map<String, dynamic>? placeholders = metadata['placeholders'];
        List<Placeholder> placeholdersList = [];
        if (placeholders != null) {
          placeholdersList = [
            for (final k in placeholders.keys)
              Placeholder(k, placeholders[k]['type'] ?? 'String',
                  example: placeholders[k]['example'] as String?,
                  format: placeholders[k]['format'] as String?),
          ];
        }
        _tokens.add(Token(
            name: tokenName,
            description: description,
            placeholders: placeholdersList));
      } else {
        throw Exception('Invalid value for key $key, expected string');
      }
    }
  }

  Token? _findTokenByName(String name) {
    return _tokens.firstWhere((token) => token.name == name);
  }

  void addToken(String name) {
    if (_findTokenByName(name) == null) {
      _tokens.add(Token(name: name));
    } else {
      throw Exception('Token with name $name already exists');
    }
  }

  void renameToken(Token token, String newName) {
    if (_findTokenByName(newName) != null) {
      throw Exception('Token with name $newName already exists');
    }
    token.name = newName;
  }

  void deleteToken(Token token) {
    _trash = token;
    _trashIndex = _tokens.indexOf(token);
    _tokens.remove(token);
    Timer(const Duration(seconds: 5), () {
      _trash = null;
      _trashIndex = null;
    });
  }

  void restoreTrash() {
    if (_trash != null) {
      _tokens.insert(_trashIndex!, _trash!);
      _trash = null;
      _trashIndex = null;
    }
  }
}
