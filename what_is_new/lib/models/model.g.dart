// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Product extends _Product with RealmEntity, RealmObjectBase, RealmObject {
  Product(
    ObjectId id,
    String raw,
    String source,
    String ownerId, {
    String? name,
    String? owner,
    DateTime? lastUpdatedDate,
    Iterable<Version> versions = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'raw', raw);
    RealmObjectBase.set(this, 'source', source);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'owner', owner);
    RealmObjectBase.set(this, 'lastUpdatedDate', lastUpdatedDate);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set<RealmList<Version>>(
        this, 'versions', RealmList<Version>(versions));
  }

  Product._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get raw => RealmObjectBase.get<String>(this, 'raw') as String;
  @override
  set raw(String value) => RealmObjectBase.set(this, 'raw', value);

  @override
  String get source => RealmObjectBase.get<String>(this, 'source') as String;
  @override
  set source(String value) => RealmObjectBase.set(this, 'source', value);

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
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

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
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('raw', RealmPropertyType.string),
      SchemaProperty('source', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('owner', RealmPropertyType.string, optional: true),
      SchemaProperty('lastUpdatedDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('versions', RealmPropertyType.object,
          linkTarget: 'Version', collectionType: RealmCollectionType.list),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
    ]);
  }
}

class Version extends _Version with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Version(
    ObjectId id,
    String version,
    String ownerId, {
    DateTime? publishDate,
    bool isReleased = false,
    Product? product,
    Iterable<Group> groups = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Version>({
        'isReleased': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'version', version);
    RealmObjectBase.set(this, 'publishDate', publishDate);
    RealmObjectBase.set(this, 'isReleased', isReleased);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'product', product);
    RealmObjectBase.set<RealmList<Group>>(
        this, 'groups', RealmList<Group>(groups));
  }

  Version._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

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
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  Product? get product =>
      RealmObjectBase.get<Product>(this, 'product') as Product?;
  @override
  set product(covariant Product? value) =>
      RealmObjectBase.set(this, 'product', value);

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
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('version', RealmPropertyType.string),
      SchemaProperty('publishDate', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('groups', RealmPropertyType.object,
          linkTarget: 'Group', collectionType: RealmCollectionType.list),
      SchemaProperty('isReleased', RealmPropertyType.bool),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('product', RealmPropertyType.object,
          optional: true, linkTarget: 'Product'),
    ]);
  }
}

class Group extends _Group with RealmEntity, RealmObjectBase, RealmObject {
  Group(
    ObjectId id,
    String name,
    String ownerId, {
    Version? version,
    Iterable<Item> items = const [],
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'version', version);
    RealmObjectBase.set<RealmList<Item>>(this, 'items', RealmList<Item>(items));
  }

  Group._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

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
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  Version? get version =>
      RealmObjectBase.get<Version>(this, 'version') as Version?;
  @override
  set version(covariant Version? value) =>
      RealmObjectBase.set(this, 'version', value);

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
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('items', RealmPropertyType.object,
          linkTarget: 'Item', collectionType: RealmCollectionType.list),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('version', RealmPropertyType.object,
          optional: true, linkTarget: 'Version'),
    ]);
  }
}

class Item extends _Item with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Item(
    ObjectId id,
    String content,
    String ownerId, {
    int number = 0,
    String? refference,
    String? example,
    Group? group,
    String checksum = "",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Item>({
        'number': 0,
        'checksum': "",
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set(this, 'number', number);
    RealmObjectBase.set(this, 'refference', refference);
    RealmObjectBase.set(this, 'example', example);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'group', group);
    RealmObjectBase.set(this, 'checksum', checksum);
  }

  Item._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get content => RealmObjectBase.get<String>(this, 'content') as String;
  @override
  set content(String value) => RealmObjectBase.set(this, 'content', value);

  @override
  int get number => RealmObjectBase.get<int>(this, 'number') as int;
  @override
  set number(int value) => RealmObjectBase.set(this, 'number', value);

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
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  Group? get group => RealmObjectBase.get<Group>(this, 'group') as Group?;
  @override
  set group(covariant Group? value) =>
      RealmObjectBase.set(this, 'group', value);

  @override
  String get checksum =>
      RealmObjectBase.get<String>(this, 'checksum') as String;
  @override
  set checksum(String value) => RealmObjectBase.set(this, 'checksum', value);

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
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('content', RealmPropertyType.string),
      SchemaProperty('number', RealmPropertyType.int),
      SchemaProperty('refference', RealmPropertyType.string, optional: true),
      SchemaProperty('example', RealmPropertyType.string, optional: true),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('group', RealmPropertyType.object,
          optional: true, linkTarget: 'Group'),
      SchemaProperty('checksum', RealmPropertyType.string),
    ]);
  }
}

class ItemSelected extends _ItemSelected
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  ItemSelected(
    ObjectId id,
    String ownerId, {
    String checksum = "",
    bool hiddden = false,
    bool selected = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<ItemSelected>({
        'checksum': "",
        'hiddden': false,
        'selected': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'checksum', checksum);
    RealmObjectBase.set(this, 'hiddden', hiddden);
    RealmObjectBase.set(this, 'selected', selected);
  }

  ItemSelected._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  String get checksum =>
      RealmObjectBase.get<String>(this, 'checksum') as String;
  @override
  set checksum(String value) => RealmObjectBase.set(this, 'checksum', value);

  @override
  bool get hiddden => RealmObjectBase.get<bool>(this, 'hiddden') as bool;
  @override
  set hiddden(bool value) => RealmObjectBase.set(this, 'hiddden', value);

  @override
  bool get selected => RealmObjectBase.get<bool>(this, 'selected') as bool;
  @override
  set selected(bool value) => RealmObjectBase.set(this, 'selected', value);

  @override
  Stream<RealmObjectChanges<ItemSelected>> get changes =>
      RealmObjectBase.getChanges<ItemSelected>(this);

  @override
  ItemSelected freeze() => RealmObjectBase.freezeObject<ItemSelected>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(ItemSelected._);
    return const SchemaObject(
        ObjectType.realmObject, ItemSelected, 'ItemSelected', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('checksum', RealmPropertyType.string),
      SchemaProperty('hiddden', RealmPropertyType.bool),
      SchemaProperty('selected', RealmPropertyType.bool),
    ]);
  }
}
