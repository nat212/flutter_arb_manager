import 'package:flutter/foundation.dart';
import 'package:flutter_i18n_manager/src/project/project_service.dart';
import 'package:flutter_i18n_manager/src/project/token.dart';

class ProjectController with ChangeNotifier {
  final ProjectService _service;

  ProjectController(this._service);

  String? get arbDir => _service.arbDir;
  String? get templateArbFile => _service.templateArbFile;
  String? get outputLocalisationFile => _service.outputLocalisationFile;
  List<Token> get tokens => _service.tokens;

  Future<void> load(String path) async {
    _service.initialise(path);
    notifyListeners();
  }

  void setL10nConfig(
      {required String arbDir,
      required String templateArbFile,
      required String outputLocalisationFile}) {
    _service.updateL10nConfig(
        arbDir: arbDir,
        templateArbFile: templateArbFile,
        outputLocalisationFile: outputLocalisationFile);
    notifyListeners();
  }

  Future<void> saveConfig() async {
    await _service.saveConfig();
  }

  void addToken(String name) {
    _service.addToken(name);
    notifyListeners();
  }

  void renameToken(Token token, String newName) {
    _service.renameToken(token, newName);
    notifyListeners();
  }

  void deleteToken(Token token) {
    _service.deleteToken(token);
    notifyListeners();
  }

  void restoreTrash() {
    _service.restoreTrash();
    notifyListeners();
  }
}
