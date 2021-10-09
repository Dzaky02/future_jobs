import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../models/user_model.dart';
import '../shared/sharedpref_keys.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _userData;

  bool get isAuth => _userData != null;

  UserModel? getUser() => this._userData;

  Future<void> register(
      String email, String password, String name, String goal) async {
    try {
      var body = {
        'name': name,
        'email': email,
        'password': password,
        'goal': goal
      };

      var response = await http.post(
          Uri.parse('https://bwa-jobs.herokuapp.com/register'),
          body: body);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        _userData = UserModel.fromJson(jsonDecode(response.body));
        notifyListeners();
        // Store auth in shared preferences
        print('AUTH: prepared to store auth data...');
        final _prefs = await SharedPreferences.getInstance();
        _prefs.setString(SharedPrefKey.USER, response.body);
        print(
            'AUTH: prefs store: ${_prefs.getString(SharedPrefKey.USER) ?? 'empty'}');
      } else {
        throw HttpException(response.body);
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      var body = {'email': email, 'password': password};

      var response = await http
          .post(Uri.parse('https://bwa-jobs.herokuapp.com/login'), body: body);

      print('Code: ' + response.statusCode.toString());
      print('Body:' + response.body);

      if (response.statusCode == 200) {
        _userData = UserModel.fromJson(jsonDecode(response.body));
        notifyListeners();
        // Store auth in shared preferences
        print('AUTH: prepared to store auth data...');
        final _prefs = await SharedPreferences.getInstance();
        _prefs.setString(SharedPrefKey.USER, response.body);
        print(
            'AUTH: prefs store: ${_prefs.getString(SharedPrefKey.USER) ?? 'empty'}');
      } else {
        throw HttpException(response.body);
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(SharedPrefKey.USER)) {
      print('AUTH: tryAutoLogin: not contain \'${SharedPrefKey.USER}\' key');
      return false;
    }

    final extractUserData = _prefs.getString(SharedPrefKey.USER);
    if (extractUserData != null && extractUserData.isNotEmpty) {
      _userData = UserModel.fromJson(jsonDecode(extractUserData));
      notifyListeners();
      return true;
    } else {
      print(
          'AUTH: tryAutoLogin: extractUserData is ${extractUserData?.isEmpty} and $extractUserData');
      return false;
    }
  }

  Future<void> logout() async {
    _userData = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear(); // clear all data
  }
}
