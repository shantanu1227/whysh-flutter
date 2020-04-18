import 'package:community/config/constants.dart';
import 'package:community/config/routes.dart';
import 'package:community/network/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:community/widgets/appBar.dart';

class RegisterScreen extends StatelessWidget {
  final _zipController = TextEditingController();
  final _nameController = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: Text('Register'), appBar: AppBar(), automaticallyImplyLeading: false, showIcon: true),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Form(
              key: _registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    maxLength: 50,
                    maxLengthEnforced: true,
                    decoration:
                        InputDecoration(labelText: "Name", hintText: "Name"),
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    validator: (String value) {
                      if (value.trim().length < 2) {
                        return 'Please enter valid name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      maxLengthEnforced: true,
                      validator: (String value) {
                        String pattern = r'[1-9][0-9]{5}$';
                        RegExp regExp = new RegExp(pattern);
                        if (!regExp.hasMatch(value)) {
                          return "Please enter a valid pincode.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Delivery Pincode",
                          hintText: "Delivery Pincode"),
                      controller: _zipController
                      ),
                  SizedBox(height: 32),
                  RegisterButton(_registerFormKey, _zipController,
                      _nameController)
                ],
              ),
            ),
          ),
        ));
  }
}

class RegisterButton extends StatefulWidget {
  final _zipController;
  final _nameController;
  final GlobalKey<FormState> _registerFormKey;

  RegisterButton(this._registerFormKey, this._zipController, this._nameController);

  @override
  _RegisterButton createState() {
    return new _RegisterButton(this._registerFormKey, this._zipController, this._nameController);
  }

}

class _RegisterButton extends State<RegisterButton> {
  final _zipController;
  final _nameController;
  final GlobalKey<FormState> _registerFormKey;
  bool isLoading = false;

  _RegisterButton(this._registerFormKey, this._zipController, this._nameController) : super();


  void registerUser(BuildContext context, String name, String zip) async {
    if (_registerFormKey.currentState.validate()) {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    try {
      await Api.registerUser(currentUser.phoneNumber, name, zip);
    } on Exception catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() {
        isLoading = false;
      });
      return;
    }
    int _zip = num.parse(zip);
    await prefs.setInt(Constants.SF_KEY_ZIP, _zip);
    await prefs.setString(Constants.SF_KEY_NAME, name);
    setState(() {
      isLoading = false;
    });
    Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.pendingTasks,
        (r) => false); 
  }
  }

  Widget getRegisterButtonChild() {
    if (isLoading) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return Text("Register");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        child: getRegisterButtonChild(),
        textColor: Colors.white,
        padding: EdgeInsets.all(16),
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          if (_registerFormKey.currentState.validate()) {
            final zip = _zipController.text.trim();
            final name = _nameController.text.trim();
            registerUser(context, name, zip);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        },
        color: Colors.blueAccent,
      ),
    );
  }
}
