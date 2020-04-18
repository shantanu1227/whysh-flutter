import 'package:community/config/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:community/widgets/appBar.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreen createState() {
    return new _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool loginButtonLoading = false;
  bool confirmButtonLoading = false;

  void verifyCredential(BuildContext context, FirebaseAuth _auth,
      AuthCredential credential) async {
    try {
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      if (user != null) {
        Navigator.pushNamed(context, RouteNames.register);
      } else {
        setState(() {
          loginButtonLoading = false;
          confirmButtonLoading = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        loginButtonLoading = false;
        confirmButtonLoading = false;
      });
    }
  }

  Future<void> loginUser(String phoneNumber, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final String country = '+91';
    _auth.verifyPhoneNumber(
        phoneNumber: country + phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          verifyCredential(context, _auth, credential);
        },
        verificationFailed: null,
        codeSent: (String verificationId, [int forceResendingToken]) async {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
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
                        child: Text('Change Number'),
                        textColor: Colors.white,
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: getConfirmButtonChild(),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            confirmButtonLoading = true;
                            loginButtonLoading = true;
                          });
                          final _code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.getCredential(
                                  verificationId: verificationId,
                                  smsCode: _code);
                          verifyCredential(context, _auth, credential);
                        },
                      )
                    ],
                  ),
                );
              });
            setState(() {
              loginButtonLoading = false;
              confirmButtonLoading = false;
            });
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Login"),
        appBar: AppBar(),
        automaticallyImplyLeading: false, 
        showIcon: true
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
                SizedBox(
                  height: 16,
                ),
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
                    child: getLoginButtonChild(),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    onPressed: loginButtonLoading?null:() {
                      setState(() {
                        loginButtonLoading = true;
                      });
                      if (_loginFormKey.currentState.validate()) {
                        final phone = _phoneController.text.trim();
                        loginUser(phone, context);
                      } else {
                        setState(() {
                          loginButtonLoading = false;
                        });
                      }
                    },
                    color: Colors.blueAccent,
                    disabledColor: Colors.blueAccent,
                  ),
                )
              ],
            )),
      )),
    );
  }

  Widget getButtonLoader() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }

  Widget getLoginButtonChild() {
    if (loginButtonLoading) {
      return getButtonLoader();
    }
    return Text('Login', style: TextStyle(fontSize: 18));
  }

  Widget getConfirmButtonChild() {
    if (confirmButtonLoading) {
      return getButtonLoader();
    }
    return Text('Confirm');
  }
}
