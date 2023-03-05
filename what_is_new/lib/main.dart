import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:what_is_new/screens/homepage.dart';
import 'package:what_is_new/screens/log_in.dart';
import 'package:what_is_new/services/app_services.dart';
import 'package:what_is_new/services/realm_services.dart';
import 'package:what_is_new/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final realmConfig = json.decode(await rootBundle.loadString('assets/atlas_app/realm_config.json'));
  const sourceFileAssetKey = 'assets/source_config.json';
  String appId = realmConfig['app_id'];

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AppServices>(create: (_) => AppServices(appId)),
    ChangeNotifierProxyProvider<AppServices, RealmServices?>(
        // RealmServices can only be initialized only if the user is logged in.
        create: (context) => null,
        update: (BuildContext context, AppServices appServices, RealmServices? realmServices) {
          return appServices.app.currentUser != null ? RealmServices(appServices.app, sourceFileAssetKey) : null;
        }),
  ], child: const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<RealmServices?>(context, listen: false)?.currentUser;

    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        title: 'Realm Flutter SDK',
        theme: appThemeData(),
        initialRoute: currentUser != null ? '/' : '/login',
        routes: {'/': (context) => const HomePage(), '/login': (context) => LogIn()},
      ),
    );
  }
}
