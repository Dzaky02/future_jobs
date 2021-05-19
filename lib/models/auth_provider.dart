import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:future_jobs/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  Future<UserModel> register(String email, String password, String goal) async {
    try {
      var body = {
        'email': email,
        'passwrord': password,
        'goal': goal,
      };

      var response = await http.post(
        Uri.parse('https://bwa-jobs.herokuapp.com/register'),
        body: body,
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
