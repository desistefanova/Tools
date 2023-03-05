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
  final Product _product;
  final StackCollection<String> _stack = StackCollection<String>();
  Version? currentVersion;
  Group? currentGroup;
  Item? currentItem;
  int index = 0;
  String bullet = "";

  MarkdownParser(this._product);

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
    if (element.tag == 'p' || element.tag == 'ol' || element.tag == 'ul' || element.tag == 'li') currentItem?.content += "\n$bullet";
    if (element.tag == "code" && _stack.get() == "pre") currentItem?.content += "\n";
    if (element.tag == "ol") bullet = " - ";
    _stack.push(element.tag);
    return true;
  }

  @override
  void visitElementAfter(md.Element element) {
    print('vea: ${element.tag}');
    if (element.tag == "ol") bullet = "";
    _stack.pop();
    if (element.tag == "li" && _stack.get() == "ul") currentItem = null;
  }

  @override
  void visitText(md.Text text) {
    print('vet: ${text.textContent}');
    String? lastLevel = _stack.get();
    switch (lastLevel) {
      case 'h1':
      case 'h2':
        currentVersion = Version(ObjectId(), text.textContent, _product.ownerId, product: _product);
        if (text.textContent.lastIndexOf("(") < text.textContent.lastIndexOf(")")) {
          final dateString = text.textContent.substring(text.textContent.lastIndexOf("(") + 1, text.textContent.lastIndexOf(")"));
          currentVersion!.isReleased = (dateString != "TBD" && dateString != "yyyy-MM-dd" && dateString != "YYYY-MM-DD");
          if (currentVersion!.isReleased) currentVersion!.publishDate = DateTime.tryParse(dateString.replaceAll("--", "-"));
        }
        _product.versions.add(currentVersion!);
        break;
      case 'h3':
        currentVersion = currentVersion ?? Version(ObjectId(), "****", _product.ownerId, product: _product);
        currentGroup = Group(ObjectId(), text.textContent, _product.ownerId, version: currentVersion);
        currentVersion!.groups.add(currentGroup!);
        break;
      case 'li':
      case 'code':
      case 'a':
      case 'p':
      case 'pre':
        if (currentVersion != null && currentGroup != null) {
          if (currentItem == null) {
            final item = Item(ObjectId(), "", _product.ownerId);
            index++;
            item.number = index;
            currentGroup = currentGroup ?? Group(ObjectId(), "****", _product.ownerId, version: currentVersion);
            item.group = currentGroup;
            currentGroup!.items.add(item);
            currentItem = item;
          }
          String codeLiteral = (lastLevel == 'code') ? "`" : "";
          currentItem?.content += "$codeLiteral${text.textContent}$codeLiteral";
          if (lastLevel == 'a') currentItem?.refference = text.textContent;
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
