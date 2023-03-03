import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:realm/realm.dart';
part 'main.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<Input> inputList = await loadInput('assets/source_config.json');
  runApp(const MyApp());
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

Future<Product> parseProduct(String raw) async {
  return Product(raw);
}

Future<Product> readProduct(String source) async {
  final response = await http.get(Uri.parse(source));

  if (response.statusCode == 200) {
    return parseProduct(response.body);
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

@RealmModel()
class _Product {
  late String raw;
  late String? name;
  late String? owner;
  late DateTime? lastUpdatedDate;
  late List<_Version> versions;
}

@RealmModel()
class _Version {
  late String version;
  late DateTime? publishDate;
  late List<_Group> groups;
  late bool isReleased = false;
}

@RealmModel()
class _Group {
  late String name;
  late List<_Item> items;
}

@RealmModel()
class _Item {
  late String content;
  late String? number;
  late String? refference;
  late String? example;
}
