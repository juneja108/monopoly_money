import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_money/game_classes/players.dart';

import 'bank.dart';

Future<Game> gameFromExisting(String gameKey, String joiningPlayerName) async {
  final db = FirebaseFirestore.instance;
  
  final snapshot = await db.collection(gameKey).get();

  final bankData = await db.collection(gameKey).doc('bank').get();
  final bankerName = bankData.data()?["banker"];

  List<Player> players = [];
  for (final doc in snapshot.docs) {
    final data = doc.data();

    if (doc.id == 'bank' || doc.id == 'logs' || doc.id == joiningPlayerName) {
      continue;
    }

    Player player = Player(gameKey, doc.id, data["banker"] as bool); 
    player.money = data["money"]; 
    players.add(player);
  }

  Bank? bank;
  for (Player player in players) { 
    if (player.name == bankerName) {
      bank = Bank(gameKey, player);
      final snapshot = await db.collection(gameKey).doc('bank').get();
      bank.money = snapshot.data()?["money"] as int;
      break;
    }
  }

  if (bank == null) {
    throw Exception("No banker found");
  }

  Game game = Game(gameKey, bank, players);
  
  return game;
}

class Game extends ChangeNotifier{
  final db = FirebaseFirestore.instance;

  String gameKey;
  List<Player> players = [];
  Bank bank;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  late Player self; 

  Game(this.gameKey, this.bank, this.players) {
    _startListening();
  }

  void _startListening() {
    // check for new players being added when new documents are detected
    _subscription = db.collection(gameKey).snapshots().listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          if (change.doc.id == 'bank' || change.doc.id == 'logs' || change.doc.id == bank.banker.name) {
            continue;
          }

          final playerName = change.doc.id;
          if (players.any((player) => player.name == playerName)) {
            continue;
          }

          final data = change.doc.data();
          if (data == null) continue;

          Player newPlayer = Player(gameKey, playerName, false);
          players.add(newPlayer);

          notifyListeners();
        }
      }
    });
  }

  void addPlayer(Player player) {
    players.add(player);
    notifyListeners();
  }

 Future<Player> authenticatePlayer({required String name, bool banker = false}) async {
  final snapshot = await db.collection(gameKey).doc(name).get();
  if (snapshot.exists) {
    final data = snapshot.data()!;
    Player player = Player(gameKey, name, data["banker"]);
    player.money = data["money"];

    self = player;

    return player;
  }
  else {
    Player player = Player(gameKey, name, banker); 
    
    await player.create();
    self = player; 

    notifyListeners();

    return player;
  }
 } 
}