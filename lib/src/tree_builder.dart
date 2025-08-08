import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'package:collection/collection.dart';

import '../flutter_widget_hierarchy.dart';

class MyVisitor extends RecursiveAstVisitor<void> {
  final List<WidgetNode> roots = [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final className = node.name.lexeme;
    final extendsClause = node.extendsClause?.superclass.name2.lexeme;

    if (extendsClause == 'StatelessWidget' ||
        extendsClause == 'StatefulWidget') {
      print('🔍 Visiting widget class: $className');

      final buildMethod = node.members
          .whereType<MethodDeclaration>()
          .firstWhereOrNull((m) => m.name.lexeme == 'build');

      if (buildMethod != null) {
        print('  ✅ Found build() method for $className');
        final widgetTree = _extractWidgetTree(buildMethod);
        if (widgetTree != null) {
          roots.add(WidgetNode(className, children: [widgetTree]));
        } else {
          print('  ⚠️ No widget tree found in build() for $className');
        }
      }
    }

    super.visitClassDeclaration(node);
  }

  WidgetNode? _extractWidgetTree(MethodDeclaration method) {
    final body = method.body;
    Expression? returnExpr;

    if (body is BlockFunctionBody) {
      for (final stmt in body.block.statements) {
        if (stmt is ReturnStatement) {
          returnExpr = stmt.expression;
          break;
        }
      }
    } else if (body is ExpressionFunctionBody) {
      returnExpr = body.expression;
    }

    if (returnExpr == null) {
      print('  ⚠️ No return expression found.');
      return null;
    }

    if (returnExpr is InstanceCreationExpression) {
      return _buildWidgetNode(returnExpr);
    }

    if (returnExpr is MethodInvocation) {
      final widgetName = returnExpr.methodName.name;
      print('  🔄 Return is a method call: $widgetName');

      // Try to parse it as a widget if it "looks" like one
      return _buildWidgetNodeFromInvocation(returnExpr);

      // Try to find the method in the same class and recurse
    }

    print(
        '  ⚠️ Return expression is not a supported widget expression (type: ${returnExpr.runtimeType})');
    return null;
  }

  WidgetNode _buildWidgetNodeFromInvocation(MethodInvocation expr) {
    final typeName = expr.methodName.name;
    final node = WidgetNode(typeName);

    for (final arg in expr.argumentList.arguments) {
      if (arg is NamedExpression) {
        final label = arg.name.label.name;
        final exprValue = arg.expression;

        if (label == 'child' && exprValue is InstanceCreationExpression) {
          node.children.add(_buildWidgetNode(exprValue));
        } else if (label == 'child' && exprValue is MethodInvocation) {
          node.children.add(_buildWidgetNodeFromInvocation(exprValue));
        } else if (label == 'children' && exprValue is ListLiteral) {
          for (final element in exprValue.elements) {
            if (element is InstanceCreationExpression) {
              node.children.add(_buildWidgetNode(element));
            } else if (element is MethodInvocation) {
              node.children.add(_buildWidgetNodeFromInvocation(element));
            }
          }
        }
      }
    }

    return node;
  }

  WidgetNode _buildWidgetNode(InstanceCreationExpression expr) {
    final typeName = expr.constructorName.type.name2.lexeme;
    final node = WidgetNode(typeName);

    for (final arg in expr.argumentList.arguments) {
      if (arg is NamedExpression) {
        final label = arg.name.label.name;
        final value = arg.expression;

        if (label == 'child' && value is InstanceCreationExpression) {
          node.children.add(_buildWidgetNode(value));
        } else if (label == 'children' && value is ListLiteral) {
          for (final child in value.elements) {
            if (child is InstanceCreationExpression) {
              node.children.add(_buildWidgetNode(child));
            }
          }
        }
      }
    }

    return node;
  }
}
