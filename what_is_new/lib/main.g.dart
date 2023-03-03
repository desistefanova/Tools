// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Product extends _Product with RealmEntity, RealmObjectBase, RealmObject {
  Product(
    String raw, {
    String? name,
    String? owner,
    DateTime? lastUpdatedDate,
    Iterable<Version> versions = const [],
  }) {
    RealmObjectBase.set(this, 'raw', raw);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'owner', owner);
    RealmObjectBase.set(this, 'lastUpdatedDate', lastUpdatedDate);
    RealmObjectBase.set<RealmList<Version>>(
        this, 'versions', RealmList<Version>(versions));
  }

  Product._();

  @override
  String get raw => RealmObjectBase.get<String>(this, 'raw') as String;
  @override
  set raw(String value) => RealmObjectBase.set(this, 'raw', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get owner => RealmObjectBase.get<String>(this, 'owner') as String?;
  @override
  set owner(String? value) => RealmObjectBase.set(this, 'owner', value);

  @override
  DateTime? get lastUpdatedDate =>
      RealmObjectBase.get<DateTime>(this, 'lastUpdatedDate') as DateTime?;
  @override
  set lastUpdatedDate(DateTime? value) =>
      RealmObjectBase.set(this, 'lastUpdatedDate', value);

  @override
  RealmList<Version> get versions =>
      RealmObjectBase.get<Version>(this, 'versions') as RealmList<Version>;
  @override
  set versions(covariant RealmList<Version> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Product>> get changes =>
      RealmObjectBase.getChanges<Product>(this);

  @override
  Product freeze() => RealmObjectBase.freezeObject<Product>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Product._);
    return const SchemaObject(ObjectType.realmObject, Product, 'Product', [
      SchemaProperty('raw', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('owner', RealmPropertyType.string, optional: true),
      SchemaProperty('lastUpdatedDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('versions', RealmPropertyType.object,
          linkTarget: 'Version', collectionType: RealmCollectionType.list),
    ]);
  }
}

class Version extends _Version with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Version(
    String version, {
    DateTime? publishDate,
    bool isReleased = false,
    Iterable<Group> groups = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Version>({
        'isReleased': false,
      });
    }
    RealmObjectBase.set(this, 'version', version);
    RealmObjectBase.set(this, 'publishDate', publishDate);
    RealmObjectBase.set(this, 'isReleased', isReleased);
    RealmObjectBase.set<RealmList<Group>>(
        this, 'groups', RealmList<Group>(groups));
  }

  Version._();

  @override
  String get version => RealmObjectBase.get<String>(this, 'version') as String;
  @override
  set version(String value) => RealmObjectBase.set(this, 'version', value);

  @override
  DateTime? get publishDate =>
      RealmObjectBase.get<DateTime>(this, 'publishDate') as DateTime?;
  @override
  set publishDate(DateTime? value) =>
      RealmObjectBase.set(this, 'publishDate', value);

  @override
  RealmList<Group> get groups =>
      RealmObjectBase.get<Group>(this, 'groups') as RealmList<Group>;
  @override
  set groups(covariant RealmList<Group> value) =>
      throw RealmUnsupportedSetError();

  @override
  bool get isReleased => RealmObjectBase.get<bool>(this, 'isReleased') as bool;
  @override
  set isReleased(bool value) => RealmObjectBase.set(this, 'isReleased', value);

  @override
  Stream<RealmObjectChanges<Version>> get changes =>
      RealmObjectBase.getChanges<Version>(this);

  @override
  Version freeze() => RealmObjectBase.freezeObject<Version>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Version._);
    return const SchemaObject(ObjectType.realmObject, Version, 'Version', [
      SchemaProperty('version', RealmPropertyType.string),
      SchemaProperty('publishDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('groups', RealmPropertyType.object,
          linkTarget: 'Group', collectionType: RealmCollectionType.list),
      SchemaProperty('isReleased', RealmPropertyType.bool),
    ]);
  }
}

class Group extends _Group with RealmEntity, RealmObjectBase, RealmObject {
  Group(
    String name, {
    Iterable<Item> items = const [],
  }) {
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<Item>>(this, 'items', RealmList<Item>(items));
  }

  Group._();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<Item> get items =>
      RealmObjectBase.get<Item>(this, 'items') as RealmList<Item>;
  @override
  set items(covariant RealmList<Item> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Group>> get changes =>
      RealmObjectBase.getChanges<Group>(this);

  @override
  Group freeze() => RealmObjectBase.freezeObject<Group>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Group._);
    return const SchemaObject(ObjectType.realmObject, Group, 'Group', [
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('items', RealmPropertyType.object,
          linkTarget: 'Item', collectionType: RealmCollectionType.list),
    ]);
  }
}

class Item extends _Item with RealmEntity, RealmObjectBase, RealmObject {
  Item(
    String content, {
    String? number,
    String? refference,
    String? example,
  }) {
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'number', number);
    RealmObjectBase.set(this, 'refference', refference);
    RealmObjectBase.set(this, 'example', example);
  }

  Item._();

  @override
  String get content => RealmObjectBase.get<String>(this, 'content') as String;
  @override
  set content(String value) => RealmObjectBase.set(this, 'content', value);

  @override
  String? get number => RealmObjectBase.get<String>(this, 'number') as String?;
  @override
  set number(String? value) => RealmObjectBase.set(this, 'number', value);

  @override
  String? get refference =>
      RealmObjectBase.get<String>(this, 'refference') as String?;
  @override
  set refference(String? value) =>
      RealmObjectBase.set(this, 'refference', value);

  @override
  String? get example =>
      RealmObjectBase.get<String>(this, 'example') as String?;
  @override
  set example(String? value) => RealmObjectBase.set(this, 'example', value);

  @override
  Stream<RealmObjectChanges<Item>> get changes =>
      RealmObjectBase.getChanges<Item>(this);

  @override
  Item freeze() => RealmObjectBase.freezeObject<Item>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Item._);
    return const SchemaObject(ObjectType.realmObject, Item, 'Item', [
      SchemaProperty('content', RealmPropertyType.string),
      SchemaProperty('number', RealmPropertyType.string, optional: true),
      SchemaProperty('refference', RealmPropertyType.string, optional: true),
      SchemaProperty('example', RealmPropertyType.string, optional: true),
    ]);
  }
}
