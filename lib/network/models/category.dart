class Category {
  final String id;
  final String name;
  final DateTime createdAt;
  
  Category({this.id, this.name, this.createdAt});

  factory Category.fromJson(Map<String, dynamic> json) {
    DateTime createdAt = json.containsKey('createdAt')?DateTime.parse(json['createdAt']):null;
    return Category(
      id: json['id'],
      name: json['name'],
      createdAt: createdAt
    );
  }

  Map toJson() {
    return {
      'id': this.id,
      'name': this.name
    };
  }
}