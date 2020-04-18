import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = const Color(0xFF3AB795);
  final Text title;
  final bool automaticallyImplyLeading;
  final bool showIcon;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const CustomAppBar({Key key, this.title, this.appBar, this.widgets, this.automaticallyImplyLeading, this.showIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarTitleElements = [
              Container(
                  padding: const EdgeInsets.all(8.0), child: title)
            ];

    if (showIcon == true) {
      appBarTitleElements.insert(0, Image.asset(
                 'assets/images/whysh-white-no-text.png',
                  fit: BoxFit.contain,
                  height: 32,
              ));
    }

    return AppBar(
      title: Row(children: appBarTitleElements),
      backgroundColor: backgroundColor,
      actions: widgets,
      automaticallyImplyLeading: automaticallyImplyLeading != null ? automaticallyImplyLeading : true
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}