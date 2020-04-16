import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class ApiHelper {
  static Future<Map> getHeaders() async{
    Map<String, String> headers = new Map<String, String>();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      IdTokenResult tr = await user.getIdToken();
      headers.putIfAbsent(HttpHeaders.authorizationHeader, () => tr.token);
    }
    headers.putIfAbsent(HttpHeaders.contentTypeHeader, () => 'application/json');
    return headers;
  }
}