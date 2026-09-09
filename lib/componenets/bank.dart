import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopoly_money/game_classes/game.dart';
import 'package:monopoly_money/game_classes/players.dart';
import 'package:monopoly_money/game_classes/bank.dart';

class BankInteractor extends StatefulWidget {
  final Game game;

  BankInteractor({super.key, required this.game});

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  State<BankInteractor> createState() => _BankInteractorState();
}

class _BankInteractorState extends State<BankInteractor> {
  @override
  void initState() {
    super.initState();

    widget.game.bank.addListener(_bankChanged);
  }
  
  void _bankChanged() { 
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.account_balance),
        const Text('BANK'), 
        const SizedBox(width: 10,),
        Text('\$${widget.game.bank.money}'),
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
          widget.game.self.sendMoney(widget.game.bank, amount, reason);
        }, child: const Text("Send money")),
        ElevatedButton(onPressed: () {
          if (widget.game.self == widget.game.bank.banker) {
            final amount = int.parse(widget._amountController.text);
            final reason = widget._reasonController.text;
            widget.game.bank.sendMoney(widget.game.self, amount, reason);
          }
        }, child: const Text("WITHDRAW MONEY")),
      ],
    );
  }
}