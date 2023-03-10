import 'package:realm/realm.dart';
part 'model.g.dart';

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
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String raw;
  late String source;
  late String? name;
  late String? owner;
  late DateTime? lastUpdatedDate;
  late List<_Version> versions = [];
  @MapTo('owner_id')
  late String ownerId;
}

@RealmModel()
class _Version {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String version;
  late DateTime? publishDate;
  late List<_Group> groups = [];
  late bool isReleased = false;
  @MapTo('owner_id')
  late String ownerId;
  late _Product? product;
}

@RealmModel()
class _Group {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String name;
  late List<_Item> items = [];
  @MapTo('owner_id')
  late String ownerId;
  late _Version? version;
}

@RealmModel()
class _Item {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String content;
  late int number = 0;
  late String? refference;
  late String? example;
  @MapTo('owner_id')
  late String ownerId;
  late _Group? group;
}
