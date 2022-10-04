import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/providers/login_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/src/homepage/homepage.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';

class ForgetPassword extends StatefulWidget {
  @override
  ForgetPasswordState createState() {
    return ForgetPasswordState();
  }
}

class ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController _emailController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: getToolbar(),
      body: _loginForm(context),
    );
  }

  Widget emailField() {
    return TextField(
      controller: _emailController,
      onChanged: (String value) {},
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: new Icon(Icons.mail_outline),
        hintText: 'you@example.com',
        labelText: 'Email Address',
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return RaisedButton(
      child: Text('Reset Password'),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0)),
      onPressed: ()  {
        resetPassword(_emailController.text,context);
      },
    );
  }

  Widget _loginForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 30.0)),
          emailField(),
          Container(margin: EdgeInsets.only(top: 8.0)),
          submitButton(context),
        ],
      ),
    );
  }

  void resetPassword(String email, BuildContext context) async {
    Auth auth = new Auth();
    try {
      await auth.resetPassword(email);

      SnackBar snackBar = new SnackBar(
        content: Text('We\'ve sent a reset message to your email'),
        backgroundColor: Colors.blue,);
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }catch(e)
    {
      SnackBar snackBar = new SnackBar(
        content: Text('Email is incorrect'),
        backgroundColor: Colors.red,);
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  AppBar getToolbar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text('Forget Password'),
    );
  }
}
