import 'dart:convert';

import 'package:community/network/api/helper.dart';
import 'package:community/network/models/task.dart';
import 'package:community/widgets/taskItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

class MockHelper extends Mock implements ApiHelper {}

const String taskJson =
    '{"id":"QxkPztwxWUdWbDy0gqjg","task":"Tomato 2kgs","address":{"flat":"Test Flat ","street1":"Street 1","street2":"Bomanhalli","pincode":123456,"city":"Bengaluru","country":"India","location":{"latitude":13.9020227,"longitude":76.6295821}},"status":"pending","categories":[{"name":"grocery"}],"createdAt":"2020-04-07T18:28:30.785Z"}';
final task = Task.fromJson(json.decode(taskJson));

void main() {
  testWidgets('Mocking Data Widget', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(
            home: new TaskItem(task, showContact: false, isCreator: false)));
    await tester.pumpWidget(testWidget);
    expect(find.text(task.task), findsOneWidget);
  });
}
