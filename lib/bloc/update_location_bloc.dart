import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/models/trade_model.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/src/utils/location_utils.dart';
import 'dart:async';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';

class UpdateLocationBloc extends Object with Validators {
  final BehaviorSubject<String> _location = BehaviorSubject<String>();

  Stream<String> get locationStream => _location.stream;

  Function(String) get changeLocationStream => _location.sink.add;

  final BehaviorSubject<String> _district = BehaviorSubject<String>();

  Stream<String> get districtStream => _district.stream;

  Function(String) get changeDistrictStream => _district.sink.add;

  final BehaviorSubject<bool> _isUpdating = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isUpdatingStream => _isUpdating.stream;

  Function(bool) get changeIsUpdatingStream => _isUpdating.sink.add;

  Stream<bool> get canUpdate => Observable.combineLatest3(
      locationStream,
      districtStream,
      isUpdatingStream,
      (loc, district, isUpdated) => true).asBroadcastStream();

  dispose() {
    // Dispose
    _location.close();
    _district.close();
    _isUpdating.close();
  }

  updateLocation(BuildContext context) async {
    _isUpdating.addError(true);
    String _locationValue = _location.value;
    String _districtValue = _district.value;

    int locationValue = LocationUtils.getEgyptLocationIndex(_locationValue);
    int districtValue = LocationUtils.getDistrictIndex(_districtValue);

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String firebase_uid = user.uid;

    NetworkHttpCalls httpCalls = new NetworkHttpCalls();
    bool updateLocationAndDistrict = await httpCalls.updateLocationAndDistrict(
        firebase_uid, locationValue, districtValue);
    if (updateLocationAndDistrict) {
      HomePageBloc _homePageBloc = HomePageProvider.of(context);
      User currentUser = _homePageBloc.getCurrentUser();
      currentUser.location = locationValue;
      currentUser.district = districtValue;
      _homePageBloc.changeCurrentUser(currentUser);
      _homePageBloc.changeHasLocation(true);
      _homePageBloc.changeHasDistrict(true);
    }
    changeIsUpdatingStream(false);
  }
}
