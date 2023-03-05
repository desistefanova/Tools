import 'package:markdown/markdown.dart' as md;
import 'package:realm/realm.dart';
import 'dart:collection';

import 'package:what_is_new/models/model.dart';

const _blockTags = [
  'blockquote',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'hr',
  'li',
  'ol',
  'p',
  'pre',
  'ul',
];

class MarkdownParser implements md.NodeVisitor {
  late Product _product;
  final StackCollection<String> _stack = StackCollection<String>();
  late RealmObject currentObject;

  MarkdownParser(this._product) : currentObject = _product;

  /// parse all lines as Markdown
  void parse(String markdownContent) {
    List<String> lines = markdownContent.split('\n');
    md.Document document = md.Document(encodeHtml: false);
    for (md.Node node in document.parseLines(lines)) {
      node.accept(this);
    }
  }

  @override
  bool visitElementBefore(md.Element element) {
    print('veb: ${element.tag}');
    _stack.push(element.tag);
    return true;
  }

  @override
  void visitElementAfter(md.Element element) {
    print('vea: ${element.tag}');
    _stack.pop();
  }

  @override
  void visitText(md.Text text) {
    print('vet: ${text.textContent}');
    String? lastLevel = _stack.get();
    switch (lastLevel) {
      case 'h2':
        final version = Version(ObjectId(), text.textContent, _product.ownerId);
        _product.versions.add(version);
        currentObject = version;
        break;
      case 'h3':
        if (currentObject is Version) {
          final group = Group(ObjectId(), text.textContent, _product.ownerId);
          (currentObject as Version).groups.add(group);
          currentObject = group;
        }
        break;
      case 'li':
        if (currentObject is Group) {
          final item = Item(ObjectId(), text.textContent, _product.ownerId);
          (currentObject as Group).items.add(item);
          currentObject = item;
        }
        break;
      case 'code':
        if (currentObject is Item) {
          final item = Item(ObjectId(), text.textContent, _product.ownerId);
          (currentObject as Item).content += "`${text.textContent}`";
          currentObject = item;
        }
        break;
      default:
    }
  }
}

class StackCollection<T> {
  final _queue = Queue<T>();

  void push(T element) {
    _queue.addLast(element);
  }

  T? pop() {
    return this.isEmpty ? null : _queue.removeLast();
  }

  T? get() {
    return this.isEmpty ? null : _queue.last!;
  }

  void clear() {
    _queue.clear();
  }

  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;
  int get length => this._queue.length;
}
