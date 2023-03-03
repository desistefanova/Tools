import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';
import 'package:what_is_new/parser.dart';
import 'model.dart';

Future<String> readProduct(Input input) async {
  final response = await http.get(Uri.parse(input.sourcePath));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load Product');
  }
}

Future<List<Input>> loadInput(String assetKey) async {
  List<Input> inputResult = [];
  final sourceConfig = json.decode(await rootBundle.loadString(assetKey));
  for (var inputJson in sourceConfig) {
    inputResult.add(Input.fromJson(inputJson));
  }
  return inputResult;
}

Future<void> saveProductsIntoRealm(String assetKey, Realm realm) async {
  final productMap = Map.fromEntries(realm.all<Product>().map((p) => MapEntry(p.source, p)));
  List<Product> products = [];
  List<Input> inputList = await loadInput(assetKey);
  for (var input in inputList) {
    String raw = await readProduct(input);
    final product = productMap[input.sourcePath];
    realm.write(() {
      if (product != null) {
        realm.delete<Product>(product);
      }
      final newProduct = Product(ObjectId(), raw, input.sourcePath, name: input.productName, owner: input.productOwner);
      realm.add(newProduct);
      MarkdownParser(newProduct).parse(raw);
    });
  }

  await realm.syncSession.waitForUpload();
}

Future<Realm> getRealm(String assetKey) async {
  final realmConfig = json.decode(await rootBundle.loadString(assetKey));
  final appConfig = AppConfiguration(realmConfig['app_id']);
  final app = App(appConfig);
  final user = await app.logIn(Credentials.anonymous());

  final flxConfig = Configuration.flexibleSync(user, [Product.schema, Version.schema, Group.schema, Item.schema]);
  var realm = Realm(flxConfig);
  print("Created local realm db at: ${realm.config.path}");

  realm.subscriptions.update((mutableSubscriptions) {
    mutableSubscriptions.clear();
    mutableSubscriptions.add(realm.all<Product>());
    mutableSubscriptions.add(realm.all<Version>());
    mutableSubscriptions.add(realm.all<Group>());
    mutableSubscriptions.add(realm.all<Item>());
  });

  await realm.subscriptions.waitForSynchronization();
  print("Syncronization completed for realm: ${realm.config.path}");
  return realm;
}
