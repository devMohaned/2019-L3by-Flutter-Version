import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
import 'package:flutter_games_exchange/src/utils/location_utils.dart';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';

class UpdateUserBloc extends Object with Validators {
  // Register
  final _updateUserFirstName = BehaviorSubject<String>();
  final _updateUserLastName = BehaviorSubject<String>();
  final _updateUserCanUpdate = BehaviorSubject<bool>();


  final BehaviorSubject<String> _location = BehaviorSubject<String>();
  final BehaviorSubject<String> _district = BehaviorSubject<String>();


  Function(String) get changeLocationStream => _location.sink.add;
  Function(String) get changeDistrictStream => _district.sink.add;





  // Retrieve Data from stream - REGISTER
  Stream<String> get updateFirstName =>
      _updateUserFirstName.stream.transform(validateName);

  Stream<String> get updateLastName => _updateUserLastName.stream.transform(validateName);

  Stream<bool> get updateCanRegister => _updateUserCanUpdate.stream;

  Stream<String> get locationStream => _location.stream;
  Stream<String> get districtStream => _district.stream;

  Stream<bool> get submitUpdateValid => Observable.combineLatest5(
      updateFirstName,
      updateLastName,
      locationStream,
      districtStream,
      updateCanRegister,
      (fn, ln,loc,district, c) => true).asBroadcastStream();

  // add data to stream -- REGISTER
  Function(String) get changeUpdateFirstName => _updateUserFirstName.sink.add;

  Function(String) get changeUpdateLastName => _updateUserLastName.sink.add;

  Function(bool) get changeUpdateCanUpdate => _updateUserCanUpdate.sink.add;


  // Register Button
  update(String validUserId, HomePageBloc _homePageBloc, BuildContext context) /* TRY REGISTER */ async {
    final validFirstName = _updateUserFirstName.value;
    final validLastName = _updateUserLastName.value;
    final validLocation = LocationUtils.getEgyptLocationIndex(_location.value);
    final validDistrict = LocationUtils.getDistrictIndex(_district.value);

    print('Update ${_location.value} INDEX ${validLocation}');


    _updateUserCanUpdate.addError(true);
      NetworkHttpCalls httpCalls = new NetworkHttpCalls();
    await httpCalls.updateUser(validFirstName, validLastName, validLocation,validDistrict,validUserId, _homePageBloc);

    Navigator.of(context).pop();

    _updateUserCanUpdate.addError(null);
  }

  String getLocationName() => _location.value;
  String getDistrictName() => _district.value;


  dispose() {
    // Dispose - REGISTER
    _updateUserFirstName.close();
    _updateUserLastName.close();
  }
}
