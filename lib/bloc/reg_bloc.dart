import 'dart:async';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';

class RegisterationBloc extends Object with Validators {
  // Register
  final _regFirstName = BehaviorSubject<String>();
  final _regLastName = BehaviorSubject<String>();
  final _regEmail = BehaviorSubject<String>();
  final _regPassword = BehaviorSubject<String>();
  final _regCanRegister = BehaviorSubject<bool>();
  final regStatus = BehaviorSubject<String>();
  final regSpinnerStatus = BehaviorSubject<int>();

  // Retrieve Data from stream - REGISTER
  Stream<String> get regFirstName =>
      _regFirstName.stream.transform(validateName);

  Stream<String> get regLastName => _regLastName.stream.transform(validateName);

  Stream<String> get regEmail => _regEmail.stream.transform(validateEmail);

  Stream<String> get regPassword =>
      _regPassword.stream.transform(validatePassword);

  Stream<bool> get regCanRegister => _regCanRegister.stream;

  Stream<bool> get submitRegValid => Observable.combineLatest5(
      regFirstName,
      regLastName,
      regEmail,
      regPassword,
      regCanRegister,
      (fn, ln, e, p, c) => true).asBroadcastStream();

  // add data to stream -- REGISTER
  Function(String) get changeRegFirstName => _regFirstName.sink.add;

  Function(String) get changeRegLastName => _regLastName.sink.add;

  Function(String) get changeRegEmail => _regEmail.sink.add;

  Function(String) get changeRegPassword => _regPassword.sink.add;

  Function(bool) get changeRegCanRegister => _regCanRegister.sink.add;

  Function(String) get changeRegStatus => regStatus.sink.add;

  Function(int) get changeRegSpinnerStatus => regSpinnerStatus.sink.add;

  // Register Button
  register(context) /* TRY REGISTER */ async {
    final validFirstName = _regFirstName.value;
    final validLastName = _regLastName.value;
    final validEmail = _regEmail.value;
    final validPassword = _regPassword.value;
    final validPlatform = "pc";

    print(
        'First name is $validFirstName, lastname $validLastName, email $validEmail,'
        ' password $validPassword');

    _regCanRegister.addError(true);
    changeRegSpinnerStatus(2);
    Auth auth = Auth();
    String userId = await auth.createUserWithEmailAndPassword(validEmail, validPassword);
    if (userId != null) {
      NetworkHttpCalls httpCalls = new NetworkHttpCalls(/*context*/);
      User user = new User(validFirstName, validLastName, userId, validEmail, validPassword,validPlatform,null,null,null,null,null,null,"DOES_EXIST");
      await httpCalls.addUser(user);
      changeRegStatus(userId);
      changeRegSpinnerStatus(1);

      print('User has sucessfully Signed up: $userId');
    } else {
      print('Could not create new account');
      changeRegSpinnerStatus(0);
    }
    _regCanRegister.addError(null);
  }

  getLastEmail()
  {
    return _regEmail.value;
  }

  dispose() {
    // Dispose - REGISTER
    _regFirstName.close();
    _regLastName.close();
    _regEmail.close();
    _regPassword.close();
  }
}
