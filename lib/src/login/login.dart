import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/providers/login_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/src/homepage/homepage.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/src/login/forget_password.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);
    return Scaffold(
      body: _getLandingPage(bloc),
    );
  }

  Widget emailField(bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: new Icon(Icons.mail_outline),
            hintText: 'you@example.com',
            labelText: 'Email Address',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
              icon: new Icon(Icons.lock),
              hintText: 'Must contain 8 characters',
              labelText: 'Password',
              errorText: snapshot.error),
          obscureText: true,
        );
      },
    );
  }

  Widget submitButton(bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Login'),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          onPressed: snapshot.hasData ? () => bloc.submit(context) : null,
        );
      },
    );
  }

  Widget registerButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "register");
      },
      child: Text("Register"),
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
          child: new Text('Forget Password'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgetPassword(),
                ));
          }),
    );
  }

  Widget _loginForm(LoginBloc bloc, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 30.0)),
          emailField(bloc),
          Container(margin: EdgeInsets.only(top: 8.0)),
          passwordField(bloc),
          Container(margin: EdgeInsets.only(top: 4.0)),
          forgetPassword(context),
          Container(margin: EdgeInsets.only(top: 30.0)),
          submitButton(bloc),
          Container(margin: EdgeInsets.only(top: 30.0)),
          registerButton(context),
        ],
      ),
    );
  }

  Widget _getLandingPage(LoginBloc bloc) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          HomePageBloc bloc = HomePageProvider.of(context);
          String firebase_uid = snapshot.data.uid;
//          bloc.getUserData(firebase_uid);
          return HomepageScreenApp(snapshot.data.email, firebase_uid, bloc);
        } else {
          return _loginForm(bloc, context);
        }
      },
    );
  }
}
