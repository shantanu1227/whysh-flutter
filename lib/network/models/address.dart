class Location {
  num latitude;
  num longitude;

  Location({this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Location(latitude: json['latitude'], longitude: json['longitude']);
  }

  Map toJson() {
    return {
      'latitude': this.latitude,
      'longitude': this.longitude
    };
  }
}

class Address {
  String flat;
  String street1;
  String street2;
  int pincode;
  String city;
  String country = 'India';
  Location location;

  Address(
      {this.flat,
      this.street1,
      this.street2,
      this.pincode,
      this.city,
      this.country: 'India',
      this.location});

  String getAddress() {
    List address = [this.flat, this.street1, this.street2, this.pincode, this.city, this.country];
    address.removeWhere((value) => value == null);
    return address.join(', ');
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        flat: json['flat'],
        street1: json['street1'],
        street2: json['street2'],
        pincode: json['pincode'],
        city: json['city'],
        country: json['country'],
        location: Location.fromJson(json['location']));
  }

  Map toJson() {
    return {
      'flat': this.flat,
      'street1': this.street1,
      'street2': this.street2,
      'pincode': this.pincode,
      'city': this.city,
      'country': this.country,
      'location': this.location.toJson()
    };
  }
}
