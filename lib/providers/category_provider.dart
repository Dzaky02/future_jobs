import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _items = [];

  UnmodifiableListView<CategoryModel> get items => UnmodifiableListView(_items);

  Future<List<CategoryModel>> refresh() async {
    _items.clear();
    return await getCategories();
  }

  Future<List<CategoryModel>> getCategories() async {
    if (_items.isEmpty) {
      try {
        var response = await http.get(
          Uri.parse('https://bwa-jobs.herokuapp.com/categories'),
        );

        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {
          List<CategoryModel> categories = [];
          List parseJson = jsonDecode(response.body);

          parseJson.forEach((category) {
            categories.add(CategoryModel.fromJson(category));
          });

          _items = categories;
          notifyListeners();
          return UnmodifiableListView(categories);
        } else {
          return [];
        }
      } catch (e) {
        print('ERROR Get Categories: $e');
        return [];
      }
    } else {
      return items;
    }
  }
}
