import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_is_new/components/app_bar.dart';
import 'package:what_is_new/components/element_list.dart';
import 'package:what_is_new/services/realm_services.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider.of<RealmServices?>(context, listen: false) == null
        ? Container()
        : Scaffold(
            appBar: DefaultAppBar(),
            body: const ElementList(),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            // floatingActionButton: const CreateItemAction(),
          );
  }
}
