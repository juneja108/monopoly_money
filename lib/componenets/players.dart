import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopoly_money/game_classes/game.dart';
import 'package:monopoly_money/game_classes/players.dart';

class PlayerInteractor extends StatefulWidget {
  final Game game;
  final Player player;

  PlayerInteractor({super.key, required this.game, required this.player});

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  State<PlayerInteractor> createState() => _PlayerInteractorState();
}

class _PlayerInteractorState extends State<PlayerInteractor> {
  @override
  void initState() {
    super.initState();

    widget.player.addListener(_playerChanged);
  }

  void _playerChanged() { 
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(widget.player.name), 
            const SizedBox(width: 10,),
            Text('\$${widget.player.money}'),
          ],
        ),
        const SizedBox(width: 10,),
        TextField(
          controller: widget._amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Amount',
          ),
        ),
        TextField(
          controller: widget._reasonController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Reason',
          ),
        ),
        const SizedBox(width: 10,), 
        ElevatedButton(onPressed: () {
          final amount = int.parse(widget._amountController.text);
          final reason = widget._reasonController.text;
          widget.game.self.sendMoney(widget.player, amount, reason);
        }, child: const Text("Send money"))
      ],
    );
  }
}