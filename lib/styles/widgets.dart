import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/styles/text_styles.dart';

class AllWidgets{

}

class TextWidgets{

  static Expanded getExpandedSettingsText(String text) {
    return Expanded(
      child: Text(text, style: TextStyles.settingsTextStyle),
    );
  }

}