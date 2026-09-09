import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'logs.dart';

abstract class BaseMoneyInteractor extends ChangeNotifier{
  final db = FirebaseFirestore.instance;

  String gameKey;

  String name;
  int money; 

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  BaseMoneyInteractor(this.gameKey, this.name, this.money) {
    _startListening();
  }

  void _startListening() { 
    _subscription = db.collection(gameKey).doc(name).snapshots().listen((snapshot) { 
      final data = snapshot.data();

      if (data == null) return; 

      final serverMoney = data["money"] as int?;

      if (serverMoney == null) return;
      
      if (serverMoney != money) {
        money = serverMoney;
        notifyListeners();
      }
    });
  }

  Future<void> create();

  Future<void> saveMoney() async {
    await db.collection(gameKey).doc(name).update({
      "money": money
    });
  }

  Future<void> sendMoney(BaseMoneyInteractor to, int amount, String reason) async {
    if (amount > money) {
      to.money += money;
    }
    else {
      to.money += amount;
    }

    money -= amount; // could also be negative, so it can show debt

    to.saveMoney();
    saveMoney();

    Log(gameKey,"'$name has sent $amount to ${to.name} for $reason").post();

    notifyListeners();
    to.notifyListeners();
  }

  @mustCallSuper
  Future<void> dispose() async {
    await _subscription?.cancel();

    super.dispose();
  }
}