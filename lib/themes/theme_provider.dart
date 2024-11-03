import 'package:flutter/material.dart';
import "package:twitter_clone/themes/light_mode.dart";
import "package:twitter_clone/themes/dark_mode.dart";

class ThemeProvider with ChangeNotifier {
  ThemeData _themedata = lighttheme;

  ThemeData get themeData {
    return _themedata;
  }

  bool get isDarkMode {
    return _themedata == darkmode;
  }

  set themeData(ThemeData themedata) {
    _themedata = themedata;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themedata == lighttheme) {
      _themedata = darkmode;
    } else {
      _themedata = lighttheme;
    }
    notifyListeners(); // Notify listeners after theme change
  }
}
