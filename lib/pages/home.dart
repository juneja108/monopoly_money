import 'package:flutter/material.dart';
import 'package:monopoly_money/componenets/bank.dart';
import 'package:monopoly_money/componenets/players.dart';
import 'package:monopoly_money/game_classes/bank.dart';

import 'package:monopoly_money/game_classes/game.dart';
import 'package:monopoly_money/game_classes/logs.dart';
import 'package:monopoly_money/game_classes/players.dart';

class JoinScreen extends StatelessWidget {
  JoinScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController gameKeyController = TextEditingController();

  late Game game; 
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Create/join a game by entering your player name and a key. Make sure the playername is all lowercase!"), 
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Enter your name',
              border: OutlineInputBorder()
            ),
          ),
          TextField(
            controller: gameKeyController,
            decoration: const InputDecoration(
              labelText: 'Enter the game key',
              border: OutlineInputBorder()
            ),
          ), 
          Row(
            children: [
              ElevatedButton(onPressed: () async {
                final String gameKey = gameKeyController.text.trim();
                final String name = nameController.text.trim();
                game = await gameFromExisting(gameKey, name);
                game.authenticatePlayer(name: name);

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameScreen(game: game)));
              }, child: const Text('Join game!')),
              ElevatedButton(onPressed: () async {
                final String gameKey = gameKeyController.text.trim();
                Player player = Player(gameKey, nameController.text.trim(), true);
                Log(gameKey, 'init').init();
                player.create();
                Bank bank = Bank(gameKey, player); 
                bank.create();
                game = Game(gameKey, bank, [player]); 
                game.self = player;

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GameScreen(game: game)));
              }, child: const Text('Create game!')),
            ],
          )
        ],
      )
    );
  }
}

class GameScreen extends StatelessWidget {
  final Game game;

  const GameScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game: ${game.gameKey}'),
      ),
      body: ListenableBuilder(
        listenable: game,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(child: BankInteractor(game: game)),

              const Divider(),

              Expanded(
                child: ListView.builder(
                  itemCount: game.players.length,
                  itemBuilder: (context, index) {
                    final player = game.players[index];
                
                    return PlayerInteractor(
                      game: game,
                      player: player,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}