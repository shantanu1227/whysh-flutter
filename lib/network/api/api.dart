import 'dart:convert';
import 'dart:io';

import 'package:community/config/constants.dart';
import 'package:community/network/models/category.dart';
import 'package:community/network/models/task.dart';
import 'package:community/network/models/tasks.dart';
import 'package:http/http.dart' as http;

import 'helper.dart';

class Api {

  static List<Category> categories;

  static Future<Tasks> getTasks(String url, {String page}) async {
    Map<String, String> headers = await ApiHelper.getHeaders();
    String requestURL = url;
    if (page != null) {
      requestURL = '$requestURL?page=$page';
    }
    final response = await http.get(requestURL, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      Tasks tasks = Tasks.fromJson(json.decode(response.body));
      tasks.currentUrl = url;
      return tasks;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load tasks');
    }
  }

  static Future<Tasks> getPendingTasks(zip, {page}) async {
    String url = Constants.BASE_URL + '/tasks/$zip/incomplete';
    return getTasks(url, page: page);
  }

  static Future<Tasks> getCreatedTasks({page}) async {
    const url = Constants.BASE_URL + '/users/creator/tasks';
    return getTasks(url, page: page);
  }

  static Future<Tasks> getAssignedTasks({page}) async {
    const url = Constants.BASE_URL + '/users/assignee/tasks';
    return getTasks(url, page: page);
  }

  static Future<void> registerUser(
      String phone, String name, String zip) async {
    const url = Constants.BASE_URL + '/users';
    Map<String, String> headers = await ApiHelper.getHeaders();
    final response = await http.post(url,
        headers: headers,
        body: jsonEncode(
            <String, dynamic>{'phone': phone, 'name': name, 'zip': zip}));
    if (response.statusCode == HttpStatus.created) {
      return;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Error while registering. ${jsonDecode(response.body)['message']}');
    }
  }

  static Future<void> assignTask(String taskId) async{
    String url = Constants.BASE_URL + '/tasks/$taskId/assign';
    Map<String, String> headers = await ApiHelper.getHeaders();
    final response = await http.patch(url, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      return;
    } else {
      throw Exception(
        'Error while assigning. ${jsonDecode(response.body)['message']}'
      );
    }
  }

  static Future<void> cancelTask(String taskId) async{
    String url = Constants.BASE_URL + '/tasks/$taskId/cancel';
    Map<String, String> headers = await ApiHelper.getHeaders();
    final response = await http.patch(url, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      return;
    } else {
      throw Exception(
          'Error while cancelling. ${jsonDecode(response.body)['message']}'
      );
    }
  }

  static Future<void> completeTask(String taskId) async{
    String url = Constants.BASE_URL + '/tasks/$taskId/complete';
    Map<String, String> headers = await ApiHelper.getHeaders();
    final response = await http.patch(url, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      return;
    } else {
      throw Exception(
          'Error while completing. ${jsonDecode(response.body)['message']}'
      );
    }
  }

  static Future<List<Category>> getCategories() async {
    if (categories != null) {
      return categories;
    }
    String url = Constants.BASE_URL + '/categories';
    Map<String, String> headers = await ApiHelper.getHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == HttpStatus.ok) {
      categories = jsonDecode(response.body)['categories'].map<Category>((_json) => Category.fromJson(_json)).toList();
      return categories;
    } else {
      throw Exception(
          'Error while getting categories. ${jsonDecode(response.body)['message']}'
      );
    }
  }

  static Future<Task> createTask(Task task) async {
    String url = Constants.BASE_URL + '/tasks';
    Map<String, String> headers = await ApiHelper.getHeaders();
    String body = jsonEncode(task.toJson());
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == HttpStatus.created) {
      return Task.fromJson(jsonDecode(response.body)['task']);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Error while registering. ${jsonDecode(response.body)['message']}');
    }
  }
}
