class WidgetNode {
  final String name;
  final List<WidgetNode> children;

  WidgetNode(this.name, {List<WidgetNode>? children})
      : children = children ?? [];

  void printTree({String indent = '', bool last = true}) {
    final pointer = last ? '└──' : '├──';
    print('$indent$pointer Widget: $name');
    final nextIndent = indent + (last ? '    ' : '│   ');
    for (var i = 0; i < children.length; i++) {
      children[i].printTree(indent: nextIndent, last: i == children.length - 1);
    }
  }
}
