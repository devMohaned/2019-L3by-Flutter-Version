import 'package:flutter/material.dart';

class ContainerStyles {
  static Container getSettingsIconContainer(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }
}
