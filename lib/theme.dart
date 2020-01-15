// Package for ChangeNotifier class
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DynamicTheme with ChangeNotifier {
  // Settings

  bool get getDarkMode {
    var val = Hive.box('flucast').get('darkMode');
    return val == null ? false : val;
  }

  void changeDarkMode(bool isDarkMode) {
    Hive.box('flucast').put('darkMode', isDarkMode);
    // Notify all it's listeners about update. If you comment this line then you will see that new added items will not be reflected in the list.
    notifyListeners();
  }
}
