import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:what_is_new/components/widgets.dart';
import 'package:what_is_new/components/element_item.dart';
import 'package:what_is_new/models/model.dart';
import 'package:what_is_new/services/realm_services.dart';
import 'package:pluto_grid/pluto_grid.dart';

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

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(title: 'Product', field: 'product', type: PlutoColumnType.text(), enableFilterMenuItem: true),
    PlutoColumn(
      title: 'Version',
      field: 'version',
      type: PlutoColumnType.text(),
      width: 100,
    ),
    PlutoColumn(
      title: 'Is released',
      field: 'released',
      type: PlutoColumnType.select(
        [false, true],
        enableColumnFilter: true,
      ),
      width: 100,
    ),
    PlutoColumn(
      title: 'Published on',
      field: 'publishDate',
      type: PlutoColumnType.date(),
      width: 100,
    ),
    PlutoColumn(
      title: 'Group',
      field: 'group',
      type: PlutoColumnType.text(),
      width: 100,
    ),
    PlutoColumn(
      title: 'Number',
      field: 'number',
      type: PlutoColumnType.number(),
      width: 100,
    ),
    PlutoColumn(
      title: 'ToDo',
      field: 'todo',
      type: PlutoColumnType.select(
        ["-", "Yes", "No"],
        enableColumnFilter: true,
      ),
      width: 100,
    ),
    PlutoColumn(
      title: 'Content',
      field: 'content',
      type: PlutoColumnType.text(),
      minWidth: 300,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    final List<PlutoRow> rows = realmServices.realm
        .query<Item>(
            "TRUEPREDICATE SORT(group.version.product.name ASC, group.version.isReleased ASC, group.version.publishDate DESC, group.name ASC, number ASC)")
        .map((r) => PlutoRow(cells: {
              'product': PlutoCell(value: r.group?.version?.product?.name),
              'version': PlutoCell(value: r.group?.version?.version),
              'released': PlutoCell(value: r.group?.version?.isReleased),
              'publishDate': PlutoCell(value: r.group?.version?.publishDate),
              'group': PlutoCell(value: r.group?.name),
              'number': PlutoCell(value: r.number),
              'todo': PlutoCell(value: "-"),
              'content': PlutoCell(value: r.content),
            }))
        .toList();

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: PlutoGrid(
                  columns: columns,
                  rows: rows,
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    stateManager = event.stateManager;
                    stateManager.setShowColumnFilter(true);
                  },
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                  },
                  configuration: const PlutoGridConfiguration(
                      style: PlutoGridStyleConfig(
                    columnTextStyle: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    cellTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                    ),
                  )),
                ),
                // StreamBuilder<RealmResultsChanges<Item>>(
                //           stream: realmServices.realm
                //               .query<Item>(
                //                   "TRUEPREDICATE SORT(group.version.product.name ASC, group.version.isReleased ASC, group.version.publishDate DESC, group.name ASC, number ASC)")
                //               .changes,
                //           builder: (context, snapshot) {
                //             final data = snapshot.data;

                //             if (data == null) return waitingIndicator();
                //             final results = data.results;
                //             return ListView.builder(
                //               shrinkWrap: true,
                //               itemCount: results.realm.isClosed ? 0 : results.length,
                //               itemBuilder: (context, index) => results[index].isValid ? ElementItem(results[index]) : Container(),
                //             );
                //           },
                //         ),
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
