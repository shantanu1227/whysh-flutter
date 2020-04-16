import 'package:community/config/constants.dart';
import 'package:community/network/models/address.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';


class AddressForm extends StatefulWidget {
  final Address address;
  AddressForm({this.address});

  @override
  _AddressForm createState() {
    return new _AddressForm(this.address);
  }

}

class _AddressForm extends State<AddressForm> {
  loc.Location location = new loc.Location();
  loc.LocationData _locationData;
  SharedPreferences prefs;
  Address address;

  Map<String, bool> validateFields = {
    'flat': false,
    'street1': false,
    'street2': false,
    'city': false
  };

  _AddressForm(this.address);

  void getLocation() async{
    loc.PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    loc.LocationData __locationData = await location.getLocation();
    setState(() {
      _locationData = __locationData;
      this.address.location = new Location(
          latitude: __locationData.latitude,
          longitude: __locationData.latitude
      );
    });
  }


  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => setState(() {
      prefs = value;
    }));
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (_locationData == null || prefs == null) {
      return Center(
        child: CircularProgressIndicator(
          semanticsLabel: "Fetching Location..." ,
        ),
      );
    }
    return Column(
      children: <Widget>[
        TextFormField(
          initialValue: prefs.getString(Constants.SF_KEY_FLAT),
          textCapitalization: TextCapitalization.words,
          maxLengthEnforced: true,
          maxLength: 50,
          autovalidate: validateFields['flat'],
          onChanged: (value) {
            setState(() {
              validateFields['flat'] = true;
            });
          },
          validator: (String value) {
            if (value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: 'Flat/Building No',
          ),
          onSaved: (val) => this.address.flat = val,
        ),
        SizedBox(
            height: 4
        ),
        TextFormField(
          initialValue: prefs.getString(Constants.SF_KEY_STREET1),
          textCapitalization: TextCapitalization.words,
          maxLengthEnforced: true,
          maxLength: 100,
          autovalidate: validateFields['street1'],
          onChanged: (value) {
            setState(() {
              validateFields['street1'] = true;
            });
          },
          validator: (String value) {
            if (value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
          decoration: InputDecoration(
              labelText: 'Street 1',
          ),
          onSaved: (val) => address.street1 = val,
        ),
        SizedBox(
            height: 4
        ),
        TextFormField(
          initialValue: prefs.getString(Constants.SF_KEY_STREET2),
          textCapitalization: TextCapitalization.words,
          autovalidate: validateFields['street2'],
          maxLengthEnforced: true,
          maxLength: 100,
          onChanged: (value) {
            setState(() {
              validateFields['street2'] = true;
            });
          },
          validator: (String value) {
            if (value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Street 2',
          ),
          onSaved: (val) => address.street2 = val,
        ),
        SizedBox(
            height: 4
        ),
        TextFormField(
          initialValue: prefs.getString(Constants.SF_KEY_CITY),
          textCapitalization: TextCapitalization.words,
          maxLengthEnforced: true,
          maxLength: 50,
          autovalidate: validateFields['city'],
          onChanged: (value) {
            setState(() {
              validateFields['city'] = true;
            });
          },
          validator: (String value) {
            if (value.isEmpty) {
              return "This field is required";
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'City',
          ),
          onSaved: (val) => address.city = val,
        ),
        SizedBox(
            height: 4
        ),
        TextFormField(
          readOnly: true,
          initialValue: prefs.getInt(Constants.SF_KEY_ZIP).toString(),
          decoration: InputDecoration(
            labelText: 'Pincode',
          ),
        ),
        SizedBox(
            height: 4
        ),
        TextFormField(
          initialValue: 'India',
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Country',
          ),
        ),
      ],
    );
  }

}