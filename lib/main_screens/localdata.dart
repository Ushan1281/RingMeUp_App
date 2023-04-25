import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class SharedPreferencesHelper {
  static final String _key = "my_object_list";

  static Future<List<Person>> getObjectList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString(_key);
    if (json != null) {
      final List<dynamic> list = jsonDecode(json);
      return list.map((e) => Person.fromJson(e)).toList();
    }
    return [];
  }

  static Future<bool> saveObjectList(List<Person> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(list.map((e) => e.toJson()).toList());
    return prefs.setString(_key, json);
  }

  static Future<bool> clearObjectList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_key);
  }
}

class Person {
  final String name;
  final String msg;
  Person({required this.name, required this.msg});
  Map<String, dynamic> toJson() => {'name': name, 'age': msg};
  factory Person.fromJson(Map<String, dynamic> json) =>
      Person(
          name: json['name'], msg: json['msg']);
       // This is a app that app can be run on the machine
}
