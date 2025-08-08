import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';

import 'package:path/path.dart' as p;

import 'tree_builder.dart';

void runCli() async {
  print('''
📦 Flutter Widget Visualizer

1. Show Page Structure Tree
2. Show Widget Tree for Specific File
3. Show Widget Trees for All Pages

Select an option (1/2/3): 
''');

  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      await _handlePageStructureTree();
      break;
    case '2':
      await _handleSingleFileWidgetTree();
      break;
    case '3':
      await _handleAllFilesWidgetTree();
      break;
    default:
      print(
          '❌ Invalid choice. Please run the program again and enter 1, 2, or 3.');
  }
}

// 👇 Option 1: Show page file hierarchy (basic)

Future<void> _handlePageStructureTree() async {
  stdout.write('📁 Enter the directory to scan for pages (default: lib): ');
  final directoryPath = stdin.readLineSync()?.trim();
  final baseDir =
      directoryPath != null && directoryPath.isNotEmpty ? directoryPath : 'lib';

  final dartFiles = Directory(baseDir)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) {
    final name = p.basename(file.path).toLowerCase();
    return name.endsWith('.dart') &&
        (name.contains('page') || name.contains('screen'));
  }).toList();

  if (dartFiles.isEmpty) {
    print('⚠️ No page files found in "$baseDir".');
    return;
  }

  final Map<String, List<String>> folderMap = {};

  for (final file in dartFiles) {
    final relativePath = p.relative(file.path, from: baseDir);
    final segments = p.split(relativePath);
    final fileName = segments.removeLast();
    final folderPath = segments.join('/');
    folderMap.putIfAbsent(folderPath, () => []).add(fileName);
  }

  print('\n📄 Page File Tree Structure:\n');

  void printTree(String currentFolder, String indent) {
    // Print all files in the current folder
    if (folderMap.containsKey(currentFolder)) {
      for (final file in folderMap[currentFolder]!) {
        print('$indent🔹 $file');
      }
    }

    // Find and print subfolders
    final currentDepth =
        currentFolder.isEmpty ? 0 : currentFolder.split('/').length;
    final subFolders = folderMap.keys
        .where((key) =>
            key.startsWith(currentFolder.isEmpty ? '' : '$currentFolder/') &&
            key.split('/').length > currentDepth)
        .map((key) => key.split('/').sublist(0, currentDepth + 1).join('/'))
        .toSet();

    for (final sub in subFolders) {
      final folderName = sub.split('/').last;
      print('$indent📂 $folderName/');
      printTree(sub, '$indent  ');
    }
  }

  print('📂 ${p.normalize(baseDir)}/');
  printTree('', '  ');
}

// 👇 Option 2: Widget tree of a single file
Future<void> _handleSingleFileWidgetTree() async {
  stdout.write('📄 Enter the full path to the Dart file: ');
  final filePath = stdin.readLineSync();

  if (filePath == null || filePath.isEmpty || !File(filePath).existsSync()) {
    print('❌ Invalid file path.');
    return;
  }

  final sourceCode = File(filePath).readAsStringSync();
  final result = parseString(content: sourceCode, path: filePath);
  final unit = result.unit;

  final visitor = MyVisitor();
  unit.accept(visitor);

  if (visitor.roots.isNotEmpty) {
    print('\n📦 Widget Tree Summary for: $filePath\n');
    for (final root in visitor.roots) {
      root.printTree();
    }
  } else {
    print('⚠️ No widget tree found in the file.');
  }
}

// 👇 Option 3: Widget tree of all Dart files in folder
Future<void> _handleAllFilesWidgetTree() async {
  stdout.write('📁 Enter the directory to scan (default: lib): ');
  final directoryPath = stdin.readLineSync()?.trim();
  final dir = directoryPath?.isNotEmpty == true ? directoryPath! : 'lib';

  final dartFiles = Directory(dir)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  for (final file in dartFiles) {
    final sourceCode = file.readAsStringSync();
    final result = parseString(content: sourceCode, path: file.path);
    final unit = result.unit;

    final visitor = MyVisitor();
    unit.accept(visitor);

    if (visitor.roots.isNotEmpty) {
      print('\n📦 Widget Tree Summary for: ${file.path}\n');
      for (final root in visitor.roots) {
        root.printTree();
      }
    }
  }
}
