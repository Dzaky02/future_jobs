import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/job_model.dart';

class JobProvider with ChangeNotifier {
  List<JobModel> _jobs = [];
  Map<String, List<JobModel>> _mapCategoriesJobs = {};

  UnmodifiableListView<JobModel> get jobs => UnmodifiableListView(_jobs);

  Future<List<JobModel>> refresh() async {
    _jobs.clear();
    return await getJobs();
  }

  Future<List<JobModel>> refreshByCategory(String category) async {
    if (_mapCategoriesJobs.containsKey(category)) {
      _mapCategoriesJobs[category]!.clear();
      _mapCategoriesJobs.remove(category);
    }
    return await getJobsByCategory(category);
  }

  JobModel findById(String idJob) =>
      _jobs.firstWhere((element) => element.id.compareTo(idJob) == 0);

  Future<List<JobModel>> getJobs() async {
    if (_jobs.isEmpty) {
      try {
        var response =
            await http.get(Uri.parse('https://bwa-jobs.herokuapp.com/jobs'));

        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {
          List<JobModel> jobs = [];
          List parsedJson = jsonDecode(response.body);

          parsedJson.forEach((job) {
            jobs.add(JobModel.fromJson(job));
          });

          _jobs = jobs;
          return UnmodifiableListView(jobs);
        }
        return [];
      } catch (e) {
        print('ERROR Get Jobs: $e');
        return [];
      }
    } else {
      return jobs;
    }
  }

  Future<List<JobModel>> getJobsByCategory(String category) async {
    if (!_mapCategoriesJobs.containsKey(category)) {
      try {
        var response = await http.get(
          Uri.parse('https://bwa-jobs.herokuapp.com/jobs?category=$category'),
        );

        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {
          List<JobModel> jobs = [];
          List parsedJson = jsonDecode(response.body);

          parsedJson.forEach((job) {
            jobs.add(JobModel.fromJson(job));
          });

          _mapCategoriesJobs.addAll({category: jobs});
          return UnmodifiableListView(jobs);
        }
        return [];
      } catch (e) {
        print('ERROR Get Job By Category: $e');
        return [];
      }
    } else {
      return UnmodifiableListView(_mapCategoriesJobs[category]!);
    }
  }

  Future<void> toggleApplyJob(String idJob) async {
    // Looking job in _jobs
    int index = _jobs.indexWhere((element) => element.id.compareTo(idJob) == 0);
    if (index > -1) {
      _jobs[index].isApplied = true;
      _mapCategoriesJobs.forEach((key, value) {
        value.forEach((element) {
          if (element.id.compareTo(idJob) == 0) {
            element.isApplied = true;
          }
        });
      });
      notifyListeners();
      return;
    } else {
      print('TOGGLE APPLY JOB: ID JOB IS NOT FOUND');
    }
  }
}
