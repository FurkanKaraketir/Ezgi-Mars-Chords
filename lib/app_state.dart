import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  Color _selectedColor = const Color(0xFFFEA501);
  Color get selectedColor => _selectedColor;

  void updateColor(Color newColor) async {
    _selectedColor = newColor;
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColor', newColor.value);
    notifyListeners();
  }

  Future<void> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedColor = Color(prefs.getInt('selectedColor') ?? 0xFFFEA501);
    notifyListeners();
  }
}
