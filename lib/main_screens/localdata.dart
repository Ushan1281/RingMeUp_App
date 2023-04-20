import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Saving object data to SharedPreferences
Future<void> saveObjectData(String key, Map<String, dynamic> data) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, json.encode(data));
}

// Reading object data from SharedPreferences
Future<Map<String, dynamic>?> getObjectData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString(key);
  if (data != null) {
    return json.decode(data);
  }
  return null;
}

// Saving list data to SharedPreferences
Future<void> saveListData(String key, List<Map<String, dynamic>> data) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList(key, data.map((item) => json.encode(item)).toList());
}

// Reading list data from SharedPreferences
Future<List?> getListData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList(key);
  if (data != null) {
    return data.map((item) => json.decode(item)).toList();
  }
  return null;
}
