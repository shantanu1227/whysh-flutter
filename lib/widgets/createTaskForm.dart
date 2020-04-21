import 'package:community/config/constants.dart';
import 'package:community/config/routes.dart';
import 'package:community/network/api/api.dart';
import 'package:community/network/models/address.dart';
import 'package:community/network/models/category.dart';
import 'package:community/network/models/task.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addressForm.dart';
import 'categories.dart';

class CreateTaskForm extends StatefulWidget {

  @override
  _CreateTaskForm createState() {
    return new _CreateTaskForm();
  }

}

class _CreateTaskForm extends State<CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  Address address;
  List<Category> categories;
  bool validateTaskDetail;
  Task task;
  bool showLoading;

  _CreateTaskForm() {
    initVariables();
  }

  void initVariables() {
    address = new Address();
    categories = [];
    validateTaskDetail = false;
    task = new Task();
    showLoading = false;
  }

  Widget getForm(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 4),
                Text('Select Category'),
                CategoriesList(categories: this.categories),
                SizedBox(height: 8),
                Text('Add Description'),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.words,
                  minLines: 1,
                  maxLines: 10,
                  autovalidate: validateTaskDetail,
                  onSaved: (val) => task.task = val,
                  onChanged: (String val) {
                    setState(() {
                      validateTaskDetail = true;
                    });
                  },
                  maxLength: 2000,
                  validator: (String val) {
                    if (val.trim().length < 6) {
                      return "Please describe your task";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Description",
                      hintText: "Ex: 1kg Onion"),
                ),
                SizedBox(height: 8),
                Text('Add Address'),
                new AddressForm(address: this.address),
                SizedBox(height: 16),
                ButtonTheme(
                  minWidth: 200,
                  child: RaisedButton(
                    onPressed: () {_createTask(context);},
                    child: Text('Create Task'),
                    color: Colors.lightBlue[700],
                    textColor: Colors.white
                )
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    final widget = getForm(context);
    return widget;
  }

  void _createTask(BuildContext context) async{
    setState(() {
      showLoading = true;
    });
    if (categories.length == 0) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please select atleast 1 category.')));
      setState(() {
        showLoading = false;
      });
      return;
    }
    if (_formKey.currentState.validate()) {
      if (address.location == null || address.location.latitude == null || address.location.longitude == null) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Location is required. Please give location permission.')));
        setState(() {
          showLoading = false;
        });
        return;
      }
      _formKey.currentState.save();
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString(Constants.SF_KEY_FLAT, address.flat);
      await pref.setString(Constants.SF_KEY_STREET1, address.street1);
      await pref.setString(Constants.SF_KEY_STREET2, address.street2);
      await pref.setString(Constants.SF_KEY_CITY, address.city);
      address.pincode = pref.getInt(Constants.SF_KEY_ZIP);
      task.address = address;
      task.categories = categories;
      try {
        await Api.createTask(task);
        await Navigator.of(context).popAndPushNamed(RouteNames.createdTasks);
      } on Exception catch(e) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
      setState(() {
        showLoading = false;
      });
    }
    return;
  }

}