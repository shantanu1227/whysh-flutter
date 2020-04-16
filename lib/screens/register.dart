import 'package:community/config/constants.dart';
import 'package:community/config/routes.dart';
import 'package:community/network/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatelessWidget {
  final _zipController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Register')),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: "Name", hintText: "Name"),
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Delivery Pincode",
                          hintText: "Delivery Pincode"),
                      controller: _zipController),
                  SizedBox(height: 32),
                  RegisterButton(_zipController, _nameController)
                ],
              ),
            ),
          ),
        ));
  }
}

class RegisterButton extends StatelessWidget {
  final _zipController;
  final _nameController;

  RegisterButton(this._zipController, this._nameController) : super();

  void registerUser(BuildContext context, String name, String zip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    try {
      await Api.registerUser(currentUser.phoneNumber, name, zip);
    } on Exception catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
    int _zip = num.parse(zip);
    await prefs.setInt(Constants.SF_KEY_ZIP, _zip);
    await prefs.setString(Constants.SF_KEY_NAME, name);
    Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.pendingTasks,
        (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        child: Text("Register"),
        textColor: Colors.white,
        padding: EdgeInsets.all(16),
        onPressed: () {
          final zip = _zipController.text.trim();
          final name = _nameController.text.trim();
          registerUser(context, name, zip);
        },
        color: Colors.blueAccent,
      ),
    );
  }
}
