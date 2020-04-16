import 'package:community/config/constants.dart';
import 'package:community/config/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  void verifyCredential(BuildContext context, FirebaseAuth _auth, AuthCredential credential) async {
    AuthResult result = await _auth.signInWithCredential(credential);
        FirebaseUser user = result.user;
        if (user != null) {
          Navigator.pushNamed(context, RouteNames.register);
        }
  }

  Future<void> loginUser(String phoneNumber, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    final String country = '+91';
    _auth.verifyPhoneNumber(
      phoneNumber: country+phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.of(context).pop();
       verifyCredential(context, _auth, credential);
      },
      verificationFailed: null,
      codeSent: (String verificationId, [int forceResendingToken]) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Verification Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _codeController,
                    maxLength: 6,
                    maxLengthEnforced: true,
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Confirm'),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    final _code = _codeController.text.trim();
                    AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: _code);
                    verifyCredential(context, _auth, credential);
                  },
                )
              ],
            );
          }
        );
      },
      codeAutoRetrievalTimeout: null
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Phone Number"),
                  controller: _phoneController,
                  validator: (String value) {
                    String pattern = r'[6-9][0-9]{9}$';
                    RegExp regExp = new RegExp(pattern);
                    if (!regExp.hasMatch(value)) {
                      return "Please enter a 10 digit valid phone number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Login"),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    onPressed: () {
                      if (_loginFormKey.currentState.validate()) {
                        final phone = _phoneController.text.trim();
                        loginUser(phone, context);
                      }
                    },
                    color: Colors.blueAccent,
                    ),
                )
              ],
            )
            ),
        )
      ),
    );
  }

  
}