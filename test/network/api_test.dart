import 'package:community/config/constants.dart';
import 'package:community/network/api/api.dart';
import 'package:community/network/api/helper.dart';
import 'package:community/network/models/tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

class MockHelper extends Mock implements ApiHelper {}

const String pendingTaskResponse =
    '{"success":true,"tasks":[{"id":"QxkPztwxWUdWbDy0gqjg","task":"Tomato 2kgs","address":{"flat":"Test Flat ","street1":"Street 1","street2":"Bomanhalli","pincode":123456,"city":"Bengaluru","country":"India","location":{"latitude":13.9020227,"longitude":76.6295821}},"status":"pending","categories":[{"name":"grocery"}],"createdAt":"2020-04-07T18:28:30.785Z"}],"next":null}';

main() {
  group('fetchPendingTasks', () {
    final helper = MockHelper();
    when(helper.getHeaders())
        .thenAnswer((_) async => Future.value(new Map<String, String>()));
    test('Success Fetch', () async {
      final headers = await helper.getHeaders();
      final client = MockClient();
      when(client.get(Constants.BASE_URL + '/tasks/123456/incomplete',
              headers: headers))
          .thenAnswer((_) async => http.Response(pendingTaskResponse, 200));
      expect(await Api.getPendingTasks(client, helper, 123456), isA<Tasks>());
    });
    test('Fail Fetch', () async {
      final headers = await helper.getHeaders();
      final client = MockClient();
      when(client.get(Constants.BASE_URL + '/tasks/123456/incomplete',
              headers: headers))
          .thenAnswer((_) async => http.Response('Not found', 404));
      expect(Api.getPendingTasks(client, helper, 123456), throwsException);
    });
  });
}
