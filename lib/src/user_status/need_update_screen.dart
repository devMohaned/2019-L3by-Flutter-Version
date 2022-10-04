import 'package:flutter/material.dart';

class NeedUpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(),
    );
  }

  Widget _getScreen() {
    return GestureDetector(onTap: openIOSStore,child: Center(
      child: Column(
        children: <Widget>[
          Container(
            width: 124,
            height: 124,
            child: new Image.asset(
              'images/need_update.png',
              width: 124.0,
              height: 124.0,
              fit: BoxFit.contain,
            ),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(24),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 24, top: 24),
              height: 48,
              padding: EdgeInsets.all(8),
              child: Text('There is a newer version of the app, please update your app.')),
        ],
      ),
    ),);
  }


  void openIOSStore(){

  }
}
