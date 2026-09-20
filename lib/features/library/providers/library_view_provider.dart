import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LibraryViewMode { list, grid }

class LibraryViewNotifier extends StateNotifier<LibraryViewMode> {
  LibraryViewNotifier() : super(LibraryViewMode.list) {
    _loadPreference();
  }

  static const _key = 'library_view_mode';

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isGrid = prefs.getBool(_key) ?? false;
    state = isGrid ? LibraryViewMode.grid : LibraryViewMode.list;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    final newMode = state == LibraryViewMode.list
        ? LibraryViewMode.grid
        : LibraryViewMode.list;
    await prefs.setBool(_key, newMode == LibraryViewMode.grid);
    state = newMode;
  }
}

final libraryViewProvider =
    StateNotifierProvider<LibraryViewNotifier, LibraryViewMode>((ref) {
      return LibraryViewNotifier();
    });
