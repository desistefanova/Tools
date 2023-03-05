import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';
import 'package:what_is_new/functions/parser.dart';
import 'package:what_is_new/models/model.dart';

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

Future<void> saveProductsIntoRealm(String assetKey, Realm realm, User user) async {
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
      final newProduct = Product(ObjectId(), raw, input.sourcePath, user.id, name: input.productName, owner: input.productOwner);
      realm.add(newProduct);
      MarkdownParser(newProduct).parse(raw);
    });
  }

  await realm.syncSession.waitForUpload();
}
