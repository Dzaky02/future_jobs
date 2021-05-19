import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:future_jobs/models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  Future<List<CategoryModel>> getCategories() async {
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

        return categories;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
