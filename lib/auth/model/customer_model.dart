import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../Transactions/model/transaction_model.dart';

class Customer {
  final String? customerName;
  final String? customerPhoneNo;
  final String? customerAddress;
  String? referenceID;
  final List<TransactionModel> transactions;
  final double totalAmount;

  // ignore: non_constant_identifier_names
  Customer(
      {required this.customerName,
      required this.customerPhoneNo,
      required this.customerAddress,
      required this.transactions,
      required this.totalAmount});
  // 4

  factory Customer.fromSnapshot(DocumentSnapshot snapshot) {
    final newCustomer =
        Customer.fromJson(snapshot.data() as Map<String, dynamic>);
    newCustomer.referenceID = snapshot.reference.id;
    return newCustomer;
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _customersFromJson(json);

  // 4
  Map<String, dynamic> toJson() => _customerToJson(this);

  @override
  String toString() => 'Passenger<$Customer>';
}

Customer _customersFromJson(Map<String, dynamic> json) {
  return Customer(
      customerName: json["customerName"],
      customerPhoneNo: json["customerPhoneNo"],
      customerAddress: json["customerAddress"],
      totalAmount: json["totalAmount"],
      transactions: _convertTransactions(json['transactionList']));
}

// 2
Map<String, dynamic> _customerToJson(Customer instance) => <String, dynamic>{
      'customerName': instance.customerName,
      'customerPhoneNo': instance.customerPhoneNo,
      'customerAddress': instance.customerAddress,
      'totalAmount': instance.totalAmount,
      'transactionList': _transactionList(instance.transactions)
    };

List<TransactionModel> _convertTransactions(List<dynamic> passengerMap) {
  final transactionList = <TransactionModel>[];

  for (final singleTransaction in passengerMap) {
    transactionList.add(
        TransactionModel.fromJson(singleTransaction as Map<String, dynamic>));
  }
  return transactionList;
}

List<Map<String, dynamic>>? _transactionList(
    List<TransactionModel>? transactionList) {
  if (transactionList == null) {
    return null;
  }
  final transacationMap = <Map<String, dynamic>>[];
  transactionList.forEach((passenger) {
    transacationMap.add(passenger.toJson());
  });
  return transacationMap;
}
