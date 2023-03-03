import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';
import 'model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Product> products = await loadProducts();

  final realmConfig = json.decode(await rootBundle.loadString('assets/atlas_app/realm_config.json'));

  Realm realm = await createRealm(realmConfig['app_id']);
  realm.write(() => realm.addAll(products));
  await realm.syncSession.waitForUpload();
  runApp(const MyApp());
}

Future<List<Product>> loadProducts() async {
  List<Product> products = [];
  List<Input> inputList = await loadInput('assets/source_config.json');
  for (var input in inputList) {
    products.add(await readProduct(input));
  }
  return products;
}

Future<Realm> createRealm(String appId) async {
  final appConfig = AppConfiguration(appId);
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<Product> parseProduct(Input input, String raw) async {
  return Product(ObjectId(), raw, name: input.productName, owner: input.productOwner);
}

Future<Product> readProduct(Input input) async {
  final response = await http.get(Uri.parse(input.sourcePath));

  if (response.statusCode == 200) {
    return await parseProduct(input, response.body);
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

class Input {
  late String sourcePath;
  late String? productName;
  late String? productOwner;

  Input({
    required this.sourcePath,
    this.productName,
    this.productOwner,
  });

  factory Input.fromJson(Map<String, dynamic> json) {
    return Input(
      sourcePath: json['sourcePath'],
      productName: json['productName'],
      productOwner: json['productOwner'],
    );
  }
}
