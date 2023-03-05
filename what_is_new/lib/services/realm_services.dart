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
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
      mutableSubscriptions.add(realm.query<Product>(r'ownerId == $0', [currentUser!.id]));
      mutableSubscriptions.add(realm.query<Version>(r'ownerId == $0', [currentUser!.id]));
      mutableSubscriptions.add(realm.query<Group>(r'ownerId == $0', [currentUser!.id]));
      mutableSubscriptions.add(realm.query<Item>(r'ownerId == $0', [currentUser!.id]));
    });

    await realm.subscriptions.waitForSynchronization();
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
      //   isWaiting = true;
      //   notifyListeners();
      await saveProductsIntoRealm(sourceFileAssetKey, realm, currentUser!);
    } finally {
      //   isWaiting = false;
      notifyListeners();
    }
  }

  void createItem(String summary, bool isComplete) {
    final newItem = Item(ObjectId(), summary, currentUser!.id);
    realm.write<Item>(() => realm.add<Item>(newItem));
    notifyListeners();
  }

  void deleteItem(Item item) {
    realm.write(() => realm.delete(item));
    notifyListeners();
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
