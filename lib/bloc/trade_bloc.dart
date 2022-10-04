import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/models/trade_model.dart';
import 'dart:async';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TradeBloc extends Object with Validators {
  final BehaviorSubject<List<TradeModel>> _tradeList = BehaviorSubject<List<TradeModel>>.seeded(new List<TradeModel>());

  Stream<List<TradeModel>> get tradeListStream => _tradeList.stream;

  Function(List<TradeModel>) get changeTradeListStream => _tradeList.sink.add;

  List<TradeModel> get getTrades => _tradeList.value;

  dispose() {
    // Dispose
    _tradeList.close();
  }

  List<TradeModel> getGames() => _tradeList.value;

}
