# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.2] - 2025-08-08

### Changed
- Improved `README.md` to better guide new users on installation and usage.

---

## [1.0.1] - 2025-08-08

### Added
- Initial CLI command `flutter_tree` for visualizing widget hierarchy from Dart files.
- Core logic to parse Dart widget trees using the `analyzer` package.
- Support for nested widget tree extraction and printing.

### Fixed
- Corrected the `executables` entry in `pubspec.yaml` to match `bin/flutter_widget_tree.dart`.

---

## [1.0.0] - 2025-08-08

### Added
- First stable release of the package.
- Basic command-line interface.
- Support for analyzing widget trees in Flutter files.
