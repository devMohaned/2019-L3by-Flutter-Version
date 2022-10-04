import 'dart:async';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@') && !email.contains(" ")) {
      sink.add(email);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8 && !password.contains(" ")) {
      sink.add(password);
    } else {
      sink.addError('Password must be at least 8 characters');
    }
  });

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
  if (name.length >= 2 && name.length < 20) {
  sink.add(name);
  } else if (name.length < 2) {
  sink.addError('Name is too short');
  } else if (name.length > 20) {
  sink.addError('Name is too long');
  } else {
  sink.addError('Name is wrong');
  }
  });


  final validatePhoneNumber =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
  if (phone.length == 11) {
  sink.add(phone);
  } else {
  sink.addError('Phone Number is wrong');
  }
  }
  );

  final validatePhoneNumber2 =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
  if (phone.length == 13) {
  sink.add(phone);
  } else {
  sink.addError('Phone Number is wrong');
  }
  }
  );

  final validateLocationSpinner =
      StreamTransformer<String, String>.fromHandlers(handleData: (location, sink) {
  if (location.length > 0) {
  sink.add(location);
  } else {
  sink.addError('Location is wrong');
  }
  }
  );


  final validateDistrictSpinner =
      StreamTransformer<String, String>.fromHandlers(handleData: (location, sink) {
  if (location.length > 0) {
  sink.add(location);
  } else {
  sink.addError('District is wrong');
  }
  }
  );

  final valideCodeNumber =
      StreamTransformer<String, String>.fromHandlers(handleData: (codeNumber, sink) {
  if (codeNumber.length == 6) {
  sink.add(codeNumber);
  } else {
  sink.addError('Code Number is wrong');
  }
  }
  );

}
