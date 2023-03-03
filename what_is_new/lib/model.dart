import 'package:realm/realm.dart';
part 'model.g.dart';

@RealmModel()
class _Product {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String raw;
  late String? name;
  late String? owner;
  late DateTime? lastUpdatedDate;
  late List<_Version> versions;
}

@RealmModel()
class _Version {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String version;
  late DateTime? publishDate;
  late List<_Group> groups;
  late bool isReleased = false;
}

@RealmModel()
class _Group {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String name;
  late List<_Item> items;
}

@RealmModel()
class _Item {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String content;
  late String? number;
  late String? refference;
  late String? example;
}
