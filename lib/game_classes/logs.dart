import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  final db = FirebaseFirestore.instance;

  String gameKey;
  String message;

  Log(this.gameKey, this.message);

  void init() {
    db.collection(gameKey).doc('logs').set({
      "logs": [message]
    });
  }

  void post() {
    db.collection(gameKey).doc('logs').update({
      "logs": FieldValue.arrayUnion([message])
    });
  }
}