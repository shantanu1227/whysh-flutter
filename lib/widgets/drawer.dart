import 'package:community/config/constants.dart';
import 'package:community/config/routes.dart';
import 'package:community/screens/landing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'appRouteObserver.dart';

class NavigationDrawer extends StatefulWidget {

  static final NavigationDrawer _singleton = NavigationDrawer._internal();

  factory NavigationDrawer() {
    return _singleton;
  }

  NavigationDrawer._internal();

  @override
  _NavigationDrawer createState() {
    return _NavigationDrawer();
  }

}

class _NavigationDrawer extends State<NavigationDrawer> with RouteAware {

  String _selectedRoute;
  AppRouteObserver _routeObserver;
  List<Route<dynamic>> routeStack = List();

  @override
  void initState() {
    super.initState();
    _routeObserver = AppRouteObserver();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }


  Future<void> _navigateTo(BuildContext context, String routeName) async {
    Navigator.pop(context);
    await Navigator.pushNamed(context, routeName);
  }

  void _updateSelectedRoute() {
    setState(() {
      _selectedRoute = ModalRoute.of(context).settings.name;
    });
  }

  _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    await Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
        (r) => false);
  }

  Widget getDrawer(BuildContext context, String name, int zip) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(child: Center(child: Text(name != null ? 'Hi, $name' : ''))),
          ListTile(
            title: Text('Help Someone'),
            onTap: () async {
              await _navigateTo(context, RouteNames.pendingTasks);
            },
            selected: _selectedRoute == RouteNames.pendingTasks,
          ),
          ListTile(
            title: Text('Create Task'),
            onTap: () async {
              await _navigateTo(context, RouteNames.createTask);
            },
            selected: _selectedRoute == RouteNames.createTask,
          ),
          ListTile(
            title: Text('Assigned Tasks'),
            onTap: () async {
              await _navigateTo(context, RouteNames.assignedTasks);
            },
            selected: _selectedRoute == RouteNames.assignedTasks,
          ),
          ListTile(
            title: Text('Created Tasks'),
            onTap: () async {
              await _navigateTo(context, RouteNames.createdTasks);
            },
            selected: _selectedRoute == RouteNames.createdTasks,
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            return getDrawer(
                context,
                snapshot.data.getString(Constants.SF_KEY_NAME),
                snapshot.data.getInt(Constants.SF_KEY_ZIP));
          }
          return Drawer();
        });
  }
}
