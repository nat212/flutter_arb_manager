import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_i18n_manager/src/settings/settings_view.dart';

class HomeView extends StatelessWidget {
  static const String routeName = '/';
  const HomeView({Key? key}) : super(key: key);

  PreferredSizeWidget _buildTitle(BuildContext context) {
    return PreferredSize(
        child: Container(
          alignment: Alignment.center,
          child: Text(AppLocalizations.of(context)!.appTitle,
              style: Theme.of(context).textTheme.headline2),
        ),
        preferredSize: const Size.fromHeight(120));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context)!.start,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6))),
              const SizedBox(height: 16.0),
              Card(
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
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ))))
            ]),
          ],
        ));
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(16.0),
      child: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).pushNamed(SettingsView.routeName);
          }),
    );
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
