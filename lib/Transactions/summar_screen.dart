import 'package:dalu_potha/Transactions/model/transaction_model.dart';
import 'package:flutter/material.dart';

class SummeryScreen extends StatefulWidget {
  final String title;
  final List<TransactionModel> lastMonthsList;
  const SummeryScreen(
      {Key? key, required this.title, required this.lastMonthsList})
      : super(key: key);

  @override
  State<SummeryScreen> createState() => _SummeryScreenState();
}

class _SummeryScreenState extends State<SummeryScreen> {
  int leafAmount = 0;
  int teaPacketAmount = 0;
  int advanceAmount = 0;

  void finalCalculation() {
    for (TransactionModel transactionModel in widget.lastMonthsList) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
    );
  }
}
