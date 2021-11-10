import 'dart:io';
import 'package:yaml/yaml.dart';

class ProjectConfigService {
  late File _l10nFile;
  late File _pubspecFile;
  late YamlMap _pubspec;
  late YamlMap _l10n;
  late String _path;
  late List<String> _locales;

  Future<void> loadProject(String path) async {
    _path = path;
    await _readConfigs();
  }

  Future<void> _readConfigs() async {
    _pubspecFile = File('$_path/pubspec.yaml');
    _pubspec = loadYaml(await _pubspecFile.readAsString());
    _l10nFile = File('$_path/l10n.yaml');
    if (_l10nFile.existsSync()) {
      _l10n = loadYaml(await _l10nFile.readAsString());
    } else {
      _l10n = YamlMap();
    }
  }

  bool get hasL10n => _l10nFile.existsSync();
  bool get hasFlutterLocalisation =>
      _pubspec['dependencies']['flutter_localizations'] != null;

  String? get arbDir => _l10n['arb-dir'];
  String? get templateArbFile => _l10n['template-arb-file'];
  String? get outputLocalisationFile => _l10n['output-localization-file'];

  void setArbDir(String arbDir) {
    _l10n['arb-dir'] = arbDir;
  }

  void setTemplateArbFile(String templateArbFile) {
    _l10n['template-arb-file'] = templateArbFile;
  }

  void setOutputLocalisationFile(String outputLocalisationFile) {
    _l10n['output-localization-file'] = outputLocalisationFile;
  }

  String _convertL10nToYaml() {
    return '''
    arb-dir: ${_l10n['arb-dir']}
    template-arb-file: ${_l10n['template-arb-file']}
    output-localization-file: ${_l10n['output-localization-file']}
    ''';
  }

  Future<void> saveL10nConfig() async {
    final l10n = File('$_path/l10n.yaml');
    await l10n.writeAsString(_convertL10nToYaml());
  }

  Future<void> addFlutterLocalisations() async {
    final result = await Process.run(
        'flutter', ['pub', 'add', 'flutter_localizations', '--sdk', 'flutter'],
        workingDirectory: _path);
    if (result.exitCode != 0) {
      throw Exception(result.stderr);
    }
  }
}
