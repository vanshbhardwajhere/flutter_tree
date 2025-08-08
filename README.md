
# 🧩 Flutter Tree

A command-line tool that parses Dart files and extracts the widget hierarchy from Flutter widget classes (`StatelessWidget` and `StatefulWidget`).  
It analyzes `build()` methods and prints a structured widget tree.

---

## 🚀 Features

- Parses Dart files to identify widget classes.
- Extracts `build()` methods and identifies root widgets.
- Supports nested `child` and `children` widgets.
- CLI interface to analyze any Dart file.
- Clean, readable output with emoji indicators.
- Shows widget relationships in tree format.

---
## 👨‍💻 Author

**Vansh**  
📧 Email: [vanshbhardwajhere@gmail.com](mailto:vanshbhardwajhere@gmail.com)

---

## 📦 Installation

### Prerequisites

- Dart SDK installed

### Option 1: Install via Pub (Recommended)

```bash
dart pub global activate flutter_widget_tree
```
### Run the Tool
```
flutter_tree
```

### Option 2: Clone the Repo

```bash
git clone https://github.com/vanshbhardwajhere/flutter_widget_tree.git
cd flutter_tree
```

### Run the Tool

```bash
dart run bin/flutter_widget_tree.dart

```
---

## 📝 Usage

```bash
📄 Enter the full path to the Dart file: path/to/your/file.dart
```

The CLI will analyze the file and output something like:

```
🔍 Visiting widget class: MyHomePage
  ✅ Found build() method for MyHomePage
  🔄 Return is a method call: Scaffold

📦 Widget Tree Summary for: path/to/your/file.dart

└── Widget: MyHomePage
    └── Widget: Scaffold
        └── Widget: AppBar
        └── Widget: Body
```

---

## 📁 Example

Use the provided sample Dart file in `/test/sample.dart` to test the tool.

---

## 📜 License

This project is open source and available under the [MIT License](LICENSE).