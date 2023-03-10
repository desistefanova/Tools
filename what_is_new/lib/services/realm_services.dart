import 'package:realm/realm.dart';
import 'package:flutter/material.dart';
import 'package:what_is_new/functions/functions.dart';
import 'package:what_is_new/models/model.dart';

class RealmServices with ChangeNotifier {
  bool showAll = false;
  bool offlineModeOn = false;
  bool isWaiting = false;
  late Realm realm;
  User? currentUser;
  App app;
  String sourceFileAssetKey;
  late Future<void> Function() exportFunction;
  late Future<void> Function() deleteRowsFunction;

  RealmServices(this.app, this.sourceFileAssetKey) {
    if (app.currentUser != null || currentUser != app.currentUser) {
      currentUser ??= app.currentUser;
      final flxConfig = Configuration.flexibleSync(currentUser!, [Product.schema, Version.schema, Group.schema, Item.schema]);
      //Realm.deleteRealm(flxConfig.path);
      realm = Realm(flxConfig);
      print("Syncronization completed for realm: ${realm.config.path}");
      updateSubscriptions();
    }
  }

  Future<void> updateSubscriptions() async {
    try {
      isWaiting = true;
      notifyListeners();
      realm.subscriptions.update((mutableSubscriptions) {
        mutableSubscriptions.clear();
        mutableSubscriptions.add(realm.query<Product>(r'ownerId == $0', [currentUser!.id]));
        mutableSubscriptions.add(realm.query<Version>(r'ownerId == $0', [currentUser!.id]));
        mutableSubscriptions.add(realm.query<Group>(r'ownerId == $0', [currentUser!.id]));
        mutableSubscriptions.add(realm.query<Item>(r'ownerId == $0', [currentUser!.id]));
      });
      await realm.subscriptions.waitForSynchronization();
    } finally {
      isWaiting = false;
      notifyListeners();
    }
  }

  Future<void> sessionSwitch() async {
    offlineModeOn = !offlineModeOn;
    if (offlineModeOn) {
      realm.syncSession.pause();
    } else {
      try {
        isWaiting = true;
        notifyListeners();
        realm.syncSession.resume();
        await updateSubscriptions();
      } finally {
        isWaiting = false;
      }
    }
    notifyListeners();
  }

  Future<void> reloadData() async {
    try {
      isWaiting = true;
      notifyListeners();
      await saveProductsIntoRealm(sourceFileAssetKey, realm, currentUser!);
    } finally {
      isWaiting = false;
      notifyListeners();
    }
  }

  Future<void> deleteSelectedData() async {
    deleteRowsFunction();
  }

  Future<void> exportToExcel() async {
    await exportFunction();
  }

  void createItem(String summary, bool isComplete) {
    final newItem = Item(ObjectId(), summary, currentUser!.id);
    realm.write<Item>(() => realm.add<Item>(newItem));
    notifyListeners();
  }

  Future<void> deleteItems(Iterable<ObjectId> idCollection) async {
    try {
      isWaiting = true;
      notifyListeners();
      final ids = idCollection.map((e) => "_id == oid($e)").join(" OR ");

      final items = realm.query<Item>(ids);
      realm.write(() => realm.deleteMany<Item>(items));
      final groups = realm.query<Group>("items.@count == 0");
      realm.write(() => realm.deleteMany<Group>(groups));
      final versions = realm.query<Version>("groups.@count == 0");
      realm.write(() => realm.deleteMany<Version>(versions));
      final products = realm.query<Product>("versions.@count == 0");
      realm.write(() => realm.deleteMany<Product>(products));

      await realm.syncSession.waitForUpload();
    } finally {
      isWaiting = false;
      notifyListeners();
    }
  }

  Future<void> updateItem(Item item, {String? content}) async {
    realm.write(() {
      if (content != null) {
        item.content = content;
      }
    });
    notifyListeners();
  }

  Future<void> close() async {
    if (currentUser != null) {
      await currentUser?.logOut();
      currentUser = null;
    }
    realm.close();
  }

  @override
  void dispose() {
    realm.close();
    super.dispose();
  }
}
