import 'package:flutter/material.dart';

class CustomAppBar extends AppBar implements PreferredSizeWidget {
  final Widget titleContent;
  final bool automaticallyImplyLeading;
  final bool showIcon;
  final List<Widget> widgets;
  final Widget title;

  /// you can add more fields that meet your needs

  CustomAppBar(
      {Key key, this.titleContent, this.widgets, this.automaticallyImplyLeading: true, this.showIcon})
      :
        title = getTitle(titleContent, showIcon),
        super(key: key,
        actions: widgets,
        automaticallyImplyLeading: automaticallyImplyLeading,
        backgroundColor: Color(0xFF3AB795),);

  static Widget getTitle(Widget titleContent, bool showIcon) {
    List<Widget> appBarTitleElements = [
      Expanded(
        child: titleContent,
      ),
    ];
    if (showIcon == true) {
      appBarTitleElements.insert(0, Image.asset(
        'assets/images/whysh-white-no-text.png',
        fit: BoxFit.contain,
        height: 32,
      ));
    }
    return Container(child: Row(children: appBarTitleElements));
  }

}