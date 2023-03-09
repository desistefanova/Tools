// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_is_new/services/app_services.dart';
import 'package:what_is_new/services/realm_services.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  DefaultAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    return AppBar(
      title: const Text('Realm Flutter To-Do'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.import_export),
          tooltip: 'Export',
          onPressed: () async => await realmServices.exportToExcel(),
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          tooltip: 'Reload',
          onPressed: () async => await realmServices.reloadData(),
        ),
        IconButton(
          icon: Icon(Icons.clear_all),
          tooltip: 'Cleare selections',
          onPressed: () async => await realmServices.clearSelectedData(),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Log out',
          onPressed: () async => await logOut(context, realmServices),
        ),
      ],
    );
  }

  Future<void> logOut(BuildContext context, RealmServices realmServices) async {
    final appServices = Provider.of<AppServices>(context, listen: false);
    appServices.logOut();
    await realmServices.close();
    Navigator.pushNamed(context, '/login');
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
