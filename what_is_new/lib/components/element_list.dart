import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:what_is_new/components/widgets.dart';
import 'package:what_is_new/models/model.dart';
import 'package:what_is_new/services/realm_services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:pluto_grid_export/pluto_grid_export.dart' as pluto_grid_export;

class ElementList extends StatefulWidget {
  const ElementList({Key? key}) : super(key: key);

  @override
  State<ElementList> createState() => _ElementListState();
}

class _ElementListState extends State<ElementList> {
  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;
  final List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];

  @override
  void initState() {
    super.initState();
    columns.addAll(getColumns());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    loadRows(realmServices);
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
                      columnSize: PlutoGridColumnSizeConfig(
                        autoSizeMode: PlutoAutoSizeMode.scale,
                        resizeMode: PlutoResizeMode.normal,
                      ),
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

  void loadRows(RealmServices realmServices) {
    var stream = realmServices.realm
        .query<Item>(
            "TRUEPREDICATE SORT(group.version.product.name ASC, group.version.isReleased ASC, group.version.publishDate DESC, group.name ASC, number ASC)")
        .changes;
    stream.listen((event) {
      PlutoGridStateManager.initializeRowsAsync(
        columns,
        event.results
            .map((r) => PlutoRow(cells: {
                  'key': PlutoCell(value: r.id),
                  'product': PlutoCell(value: r.group?.version?.product?.name),
                  'version': PlutoCell(value: r.group?.version?.version),
                  'released': PlutoCell(value: r.group?.version?.isReleased),
                  'publishDate': PlutoCell(value: r.group?.version?.publishDate),
                  'group': PlutoCell(value: r.group?.name),
                  'number': PlutoCell(value: r.number),
                  'content': PlutoCell(value: r.content),
                  'refference': PlutoCell(value: r.refference)
                }))
            .toList(),
      ).then((value) {
        realmServices.exportFunction = _defaultExportGridAsCSVCompatibleWithExcel;
        realmServices.deleteRowsFunction = _deleteSelectedRows;
        stateManager.refRows.addAll(value);

        stateManager.setRowGroup(PlutoRowGroupByColumnDelegate(
          columns: [
            columns[1],
            columns[2],
          ],
          showFirstExpandableIcon: false,
        ));

        stateManager.setShowLoading(false);
        setState(() {});
      });
    });
  }

  static List<PlutoColumn> getColumns() {
    return <PlutoColumn>[
      PlutoColumn(
        title: 'Key',
        field: 'key',
        type: PlutoColumnType.text(),
        enableFilterMenuItem: false,
        hide: true,
      ),
      PlutoColumn(
        title: 'Product',
        field: 'product',
        type: PlutoColumnType.text(),
        enableFilterMenuItem: false,
      ),
      PlutoColumn(
        title: 'Group',
        field: 'group',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        width: 100,
      ),
      PlutoColumn(
        title: 'Published on',
        field: 'publishDate',
        type: PlutoColumnType.date(),
        enableEditingMode: false,
        width: 100,
      ),
      PlutoColumn(
        title: 'Content',
        field: 'content',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        enableRowChecked: true,
        minWidth: 300,
      ),
      PlutoColumn(
        title: 'Refference',
        field: 'refference',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        minWidth: 300,
      ),
      PlutoColumn(
        title: 'Version',
        field: 'version',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        width: 100,
      ),
      PlutoColumn(
        title: 'Is released',
        field: 'released',
        type: PlutoColumnType.text(),
        enableEditingMode: false,
        formatter: (value) => value ?? false ? "yes" : " ",
        width: 100,
      ),
      PlutoColumn(
        title: 'Number',
        field: 'number',
        type: PlutoColumnType.number(),
        enableEditingMode: false,
        width: 100,
      ),
    ];
  }

  Future<void> _defaultExportGridAsCSVCompatibleWithExcel() async {
    String title = "pluto_grid_export";
    var exportCSV = pluto_grid_export.PlutoGridExport.exportCSV(stateManager);
    var exported = const Utf8Encoder().convert(
        // FIX Add starting \u{FEFF} / 0xEF, 0xBB, 0xBF
        // This allows open the file in Excel with proper character interpretation
        // See https://stackoverflow.com/a/155176
        '\u{FEFF}$exportCSV');

    // await FileSaver.instance.saveFile("/Users/desim1/$title.csv", exported, ".csv");
    String? outputFile = await FilePicker.platform.saveFile(dialogTitle: 'Save Your File to desired location', fileName: "$title.csv");

    try {
      File returnedFile = File('$outputFile');
      await returnedFile.writeAsBytes(exported);
    } catch (e) {}
  }

  Future<void> _deleteSelectedRows() async {
    final realmServices = Provider.of<RealmServices>(context, listen: false);

    var toDelete = stateManager.iterateAllRow.where((r) => r.checked ?? false);
    final ids = toDelete.where((e) => e.cells["key"] != null).map((e) => e.cells["key"]!.value as ObjectId);
    await realmServices.deleteItems(ids);

    stateManager.removeRows(toDelete.toList(), notify: true);
  }
}
