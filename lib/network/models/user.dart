class User {
  String name;
  String phone;

  User({this.name, this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return User(
      name: json['name'],
      phone: json['phone']
    );
  }

}