import 'package:flutter/material.dart';
import 'package:future_jobs/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;

  UserModel get user => this._user;

  set user(UserModel newUser) {
    this._user = newUser;
    notifyListeners();
  }
}
