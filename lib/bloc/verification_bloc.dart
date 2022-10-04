import 'dart:async';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationBloc extends Object with Validators {
  // Verification Phone Number
  final _verifyPhoneNumber = BehaviorSubject<String>();
  final _verifyCodeNumber = BehaviorSubject<String>();

  // Retrieve Data from streams - Verification Phone Number
  Stream<String> get verifyPhoneNumber =>
      _verifyPhoneNumber.stream.transform(validatePhoneNumber2);

  Stream<String> get verifyCodeNumber =>
      _verifyCodeNumber.stream.transform(valideCodeNumber);

  // add data to streams -- Verification Phone Number
  Function(String) get changeVerifyPhoneNumber => _verifyPhoneNumber.sink.add;

  Function(String) get changeVerifyCodeNumber => _verifyCodeNumber.sink.add;

  // Verification Phone Number Button
  // Sends the code to the specified phone number.
  String verificationId;

  Future<void> sendCodeToPhoneNumber() async {
    final validPhoneNumber = _verifyPhoneNumber.value;
    final valideCodeNumber = _verifyCodeNumber.value;

    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      print(
          'XMZInside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
    } as PhoneVerificationCompleted;

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(
          'XMZPhone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print(
          "XMZcode sent to " + /*_phoneNumberController.text*/ verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("XMZtime out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: validPhoneNumber,
        timeout: const Duration(seconds: 15),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  dispose() {
    // Dispose - Verification
    _verifyPhoneNumber.close();
    _verifyCodeNumber.close();
  }
}
