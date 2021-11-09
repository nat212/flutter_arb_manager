import 'package:flutter/material.dart';
import 'package:flutter_i18n_manager/src/home/home_view.dart';
import 'package:flutter_i18n_manager/src/settings/settings_controller.dart';
import 'package:flutter_i18n_manager/src/settings/settings_view.dart';
import 'package:flutter_i18n_manager/src/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  final SettingsController settingsController;

  const App({Key? key, required this.settingsController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            restorationScopeId: 'app',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: themeData,
            themeMode: settingsController.themeMode,
            darkTheme: darkThemeData,
            initialRoute: HomeView.routeName,
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                  settings: settings,
                  builder: (BuildContext context) {
                    switch (settings.name) {
                      case HomeView.routeName:
                        return const HomeView();
                      case SettingsView.routeName:
                        return SettingsView(
                            settingsController: settingsController);
                      default:
                        return const HomeView();
                    }
                  });
            },
          );
        });
  }
}
