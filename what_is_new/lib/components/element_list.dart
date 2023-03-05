import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:what_is_new/components/widgets.dart';
import 'package:what_is_new/components/element_item.dart';
import 'package:what_is_new/models/model.dart';
import 'package:what_is_new/services/realm_services.dart';

class ElementList extends StatefulWidget {
  const ElementList({Key? key}) : super(key: key);

  @override
  State<ElementList> createState() => _ElementListState();
}

class _ElementListState extends State<ElementList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    return Stack(
      children: [
        Column(
          children: [
            styledBox(
              context,
              isHeader: true,
              child: Row(
                children: [
                  const Expanded(
                    child: Text("Show All Tasks", textAlign: TextAlign.right),
                  ),
                  Switch(
                    value: realmServices.showAll,
                    onChanged: (value) async {
                      if (realmServices.offlineModeOn) {
                        infoMessageSnackBar(context, "Switching subscriptions does not affect Realm data when the sync is offline.").show(context);
                      }
                      await realmServices.sessionSwitch();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: StreamBuilder<RealmResultsChanges<Item>>(
                  stream: realmServices.realm.query<Item>("TRUEPREDICATE SORT(number ASC)").changes,
                  builder: (context, snapshot) {
                    final data = snapshot.data;

                    if (data == null) return waitingIndicator();
                    final results = data.results;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: results.realm.isClosed ? 0 : results.length,
                      itemBuilder: (context, index) => results[index].isValid ? ElementItem(results[index]) : Container(),
                    );
                  },
                ),
              ),
            ),
            styledBox(
              context,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 40, 15),
                  child: const Text(
                    "Log in with the same account on another device to see your list sync in realm-time.",
                    textAlign: TextAlign.left,
                  )),
            ),
          ],
        ),
        realmServices.isWaiting ? waitingIndicator() : Container(),
      ],
    );
  }
}
