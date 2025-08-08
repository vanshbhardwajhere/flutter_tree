import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:flutter_widget_tree/flutter_widget_hierarchy.dart';
import 'package:test/test.dart';

void main() {
  test('Extracts widget hierarchy from sample Dart code', () {
    const sampleCode = '''
      import 'package:flutter/widgets.dart';

      class MyWidget extends StatelessWidget {
        @override
        Widget build(BuildContext context) {
          return Container(
            child: Column(
              children: [
                Text('Hello'),
                Icon(Icons.star),
              ],
            ),
          );
        }
      }
    ''';

    final parseResult = parseString(content: sampleCode);
    final visitor = MyVisitor();
    parseResult.unit.visitChildren(visitor);

    expect(visitor.roots.length, 1);
    expect(visitor.roots.first.name, 'MyWidget');
    expect(visitor.roots.first.children.first.name, 'Container');
    expect(visitor.roots.first.children.first.children.first.name, 'Column');
  });
}
