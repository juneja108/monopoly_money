import 'package:monopoly_money/game_classes/base_money_interactor.dart';
import 'package:monopoly_money/game_classes/players.dart';
import 'logs.dart';

class Bank extends BaseMoneyInteractor{  
  Player banker;

  Bank(String gameKey, this.banker) : super(gameKey, 'bank', 20580);

  @override
  Future<void> create() async {
    await db.collection(gameKey).doc('bank').set({
      "banker": banker.name, 
      "money": money
    });

    Log(gameKey, '$name has joined the game!').post();
  }
}