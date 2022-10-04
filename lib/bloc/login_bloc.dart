import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';

class LoginBloc extends Object with Validators {

  // Login
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  // retrieve data from stream - LOGIN
  Stream<String> get email => _email.stream.transform(validateEmail);

  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(email, password, (e, p) => true);

  // add data to stream -- LOGIN
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  submit(context) async {
    final validEmail = _email.value;
    final validPassword = _password.value;

    Auth auth = Auth();
    String userId =
        await auth.signInWithEmailAndPassword(validEmail, validPassword);
    if (userId != null) {
//      Navigator.pushNamed(context, 'homepage');
    }

    print('$validEmail and $validPassword');
  }


  dispose() {
    // Dispose - LOGIN
    _email.close();
    _password.close();
  }
}
