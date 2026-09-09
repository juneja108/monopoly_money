import 'package:monopoly_money/game_classes/base_money_interactor.dart';
import 'logs.dart';

class Player extends BaseMoneyInteractor{
  bool banker;

  Player(String gameKey, String name, this.banker) : super(gameKey, name, 1500);

  @override
  Future<void> create() async {
    await db.collection(gameKey).doc(name).set({
      "name": name,
      "money": money,
      "banker": banker,
    });

    Log(gameKey, '$name has joined the game!').post();
  }


}