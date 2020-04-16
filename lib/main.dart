import 'package:community/screens/assignedTasks.dart';
import 'package:community/screens/createTask.dart';
import 'package:community/screens/createdTasks.dart';
import 'package:community/screens/login.dart';
import 'package:community/screens/pendingTasks.dart';
import 'package:community/screens/register.dart';
import 'package:community/widgets/appRouteObserver.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

import 'config/routes.dart';
import 'screens/landing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Whysh',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        initialRoute: RouteNames.home,
        navigatorObservers: [AppRouteObserver(), observer],
        routes: {
          RouteNames.home: (_) => LandingPage(),
          RouteNames.login: (_) => LoginScreen(),
          RouteNames.register: (_) => RegisterScreen(),
          RouteNames.pendingTasks: (_) => PendingTasksScreen(),
          RouteNames.createTask: (_) => CreateTaskScreen(),
          RouteNames.assignedTasks: (_) => AssignedTasksScreen(),
          RouteNames.createdTasks: (_) => CreatedTasksScreen()
        });
  }
}
