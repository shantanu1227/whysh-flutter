import 'package:community/network/api/api.dart';
import 'package:community/network/models/category.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  final List<Category> categories;

  CategoriesList({this.categories});

  @override
  _CategoriesList createState() {
    return new _CategoriesList(this.categories);
  }
}

class _CategoriesList extends State<CategoriesList> {
  List<String> selectedCategories = [];
  Map<String, Category> _categories;
  List<Category> categories;

  _CategoriesList(this.categories);

  @override
  void initState() {
    super.initState();
    Api.getCategories().then((categories) {
      setState(() {
        _categories =
            Map.fromIterable(categories, key: (e) => e.name, value: (e) => e);
      });
    });
  }

  void handleCheck(bool value, String key) {
    if (value) {
      setState(() {
        selectedCategories.add(key);
      });
    } else {
      setState(() {
        selectedCategories.remove(key);
      });
    }
    categories.clear();
    categories.addAll(selectedCategories.map((e) => _categories[e]));
  }

  @override
  Widget build(BuildContext context) {
    if (_categories == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: <Widget>[
        new ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: _categories.keys.map((String key) {
              return new CheckboxListTile(
                  title: new Text(key.toUpperCase()),
                  value: selectedCategories.contains(key),
                  onChanged: (bool value) {
                    handleCheck(value, key);
                  });
            }).toList())
      ],
    );
  }
}
