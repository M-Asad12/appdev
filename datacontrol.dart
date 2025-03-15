import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataControl {
  static const String _key = "users";

  // Save user data
  static Future<void> saveUser(Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_key) ?? [];

    users.add(jsonEncode(user)); // Convert map to JSON string
    await prefs.setStringList(_key, users);
  }

  // Retrieve user data
  static Future<List<Map<String, dynamic>>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? users = prefs.getStringList(_key);

    if (users == null) return []; // Return an empty list if no users found

    return users
        .map((user) => jsonDecode(user) as Map<String, dynamic>)
        .toList();
  }

  // Delete user by index
  static Future<void> deleteUser(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_key) ?? [];

    if (index >= 0 && index < users.length) {
      users.removeAt(index);
      await prefs.setStringList(_key, users);
    }
  }

  // Clear all saved users
  static Future<void> clearAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
