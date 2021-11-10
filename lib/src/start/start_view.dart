import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_i18n_manager/src/project/project_service.dart';
import 'package:flutter_i18n_manager/src/project_config/project_config_service.dart';
import 'package:flutter_i18n_manager/src/settings/settings_view.dart';
import 'dart:io';

class StartView extends StatefulWidget {
  static const String routeName = '/';
  const StartView({Key? key}) : super(key: key);

  @override
  _StartViewState createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  bool _startHovering = false;
  bool _recentHovering = false;

  PreferredSizeWidget _buildTitle(BuildContext context) {
    return PreferredSize(
        child: Container(
          alignment: Alignment.center,
          child: Text(AppLocalizations.of(context)!.appTitle,
              style: Theme.of(context).textTheme.headline2),
        ),
        preferredSize: const Size.fromHeight(120));
  }

  Widget _startCard(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => _startHovering = true),
      onExit: (event) => setState(() => _startHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: _openDirectory,
          child: Card(
              elevation: _startHovering ? 8 : 2,
              child: SizedBox(
                  width: 256,
                  height: 256,
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 32.0),
                      Text(
                        AppLocalizations.of(context)!.openFolder,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ))))),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppLocalizations.of(context)!.start,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6))),
          const SizedBox(height: 16.0),
          _startCard(context),
        ]),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(32.0),
      child: IconButton(
          tooltip: AppLocalizations.of(context)!.settingsTitle,
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).pushNamed(SettingsView.routeName);
          }),
    );
  }

  void _openDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      await ProjectService(ProjectConfigService())
          .initialise(selectedDirectory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildTitle(context),
        body: _buildBody(context),
        extendBody: true,
        bottomNavigationBar: _buildFooter(context));
  }
}
