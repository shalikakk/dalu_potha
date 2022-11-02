import 'package:meta/meta.dart';

class TransactionModel {
  final String? transaction_type;
  final String? transaction_dttm;
  final double? amount;

  TransactionModel({this.transaction_dttm, this.amount, this.transaction_type});

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _passangerFromJson(json);

  Map<String, dynamic> toJson() => _passangerToJson(this);
}

TransactionModel _passangerFromJson(Map<String, dynamic> json) {
  return TransactionModel(
      transaction_dttm: json["transaction_dttm"],
      amount: json["amount"],
      transaction_type: json["transaction_type"]);
}

// 2
Map<String, dynamic> _passangerToJson(TransactionModel instance) =>
    <String, dynamic>{
      'transaction_dttm': instance.transaction_dttm,
      'amount': instance.amount,
      'transaction_type': instance.transaction_type
    };
