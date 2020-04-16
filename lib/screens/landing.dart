import 'package:community/config/constants.dart';
import 'package:community/config/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPage createState() {
    return new _LandingPage();
  }
}

class _LandingPage extends State<LandingPage> {
  int zip;

  _LandingPage() {
    getUserZip().then((value) => setState(() {
      zip = value;
    }));
  }

  redirectBasedOnData(BuildContext context, FirebaseUser user){
    String redirectTo;
    if (user == null) {
      //login screen
      redirectTo = RouteNames.login;
    } else {
      if (zip == null) {
        redirectTo = RouteNames.register;
      } else {
        redirectTo = RouteNames.pendingTasks;
      }
    }
    Future.microtask(() => Navigator.pushNamed(context, redirectTo));
  }

  Future<int> getUserZip() {
    return SharedPreferences.getInstance().then((prefs) => prefs.getInt(Constants.SF_KEY_ZIP));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser> (
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          redirectBasedOnData(context, snapshot.data);
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    );
  }
}