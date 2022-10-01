import 'package:cloud_firestore/cloud_firestore.dart';

import 'customer_model.dart';

class Business {
  String? referenceID;
  final String? ownerName;
  final String? businessName;
  final String? businessPhoneNo;
  final String? businessAddress;

  // final List<Customer> customers;

  // ignore: non_constant_identifier_names
  Business(
    this.referenceID,
    this.ownerName,
    this.businessName,
    this.businessPhoneNo,
    this.businessAddress,
    //required this.customers
  );

  Map<String, dynamic> toJson() {
    return {
      'referenceID': referenceID,
      'ownerName': ownerName,
      'businessName': businessName,
      'businessPhoneNo': businessPhoneNo,
      'businessAddress': businessAddress,
    };
  }

  @override
  String toString() {
    return 'Business { ownerName: $ownerName, businessName: $businessName, businessPhoneNo: $businessPhoneNo, businessAddress: $businessAddress }';
  }

  static Business fromJson(Map<String, dynamic> json) {
    return Business(
      json["referenceID"],
      json["ownerName"],
      json["businessPhoneNo"],
      json["businessName"],
      json["businessAddress"],
      // customers: _convertPassengers(json['passengerList'])
    );
  }

  static Business fromSnapshot(DocumentSnapshot snap) {
    final newBusiness = Business.fromJson(snap.data() as Map<String, dynamic>);
    newBusiness.referenceID = snap.reference.id;
    return newBusiness;
  }

  Map<String, Object> toDocument() {
    return {
      'ownerName': ownerName.toString(),
      'businessName': businessName.toString(),
      'businessPhoneNo': businessPhoneNo.toString(),
      'businessAddress': businessAddress.toString(),
    };
  }
}
//
// List<Customer> _convertPassengers(List<dynamic> passengerMap) {
//   final passengers = <Customer>[];
//
//   for (final passenger in passengerMap) {
//     passengers.add(Customer.fromJson(passenger as Map<String, dynamic>));
//   }
//   return passengers;
// }
//
// List<Map<String, dynamic>>? _customerList(List<Customer>? customerList) {
//   if (customerList == null) {
//     return null;
//   }
//   final customerMap = <Map<String, dynamic>>[];
//   customerList.forEach((customer) {
//     customerMap.add(customer.toJson());
//   });
//   return customerMap;
// }
