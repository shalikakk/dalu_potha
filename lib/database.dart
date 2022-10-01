import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalu_potha/Transactions/model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'auth/model/busines_model.dart';
import 'auth/model/customer_model.dart';

class DataRepository extends ChangeNotifier {
  final CollectionReference businessCollection =
      FirebaseFirestore.instance.collection('user');

  void getEmail() {
    var currentUser = FirebaseAuth.instance.currentUser?.email;
    if (currentUser!.isNotEmpty) {
      notifyListeners();
    }
  }

  Future addNewBusiness(Business business, String email) async {
    Business _business = business;
    _business.referenceID = email;
    return businessCollection.doc(email).set(_business.toJson());
  }

  Future addCustomer(Customer customer) async {
    var currentUser = FirebaseAuth.instance.currentUser?.email;

    //await getEmail().then((value) => {email = value});
    businessCollection
        .doc(currentUser)
        .collection("customers")
        .add(customer.toJson())
        .then((value) {
      return null;
    }).catchError((error) {
      return error;
    });
  }

  Stream<QuerySnapshot> getAllCustomers(String email) {
    return businessCollection.doc(email).collection("customers").snapshots();
  }

  Future<void> updatePassengersConnectedWithDRiver(
      String email,
      TransactionModel transactionModel,
      String customerReferenceId,
      double total) async {
    await businessCollection
        .doc(email)
        .collection("customers")
        .doc(customerReferenceId)
        .update({
      "totalAmount": total,
      "transactionList": FieldValue.arrayUnion([transactionModel.toJson()])
    });

    // _prefs.then((SharedPreferences prefs) {
    //   return prefs.getString('user_email') ?? "";
    // }).then((value) async => {
    //       await businessCollection
    //           .doc(value)
    //           .collection("customers")
    //           .doc(customerReferenceId)
    //           .update({
    //         "totalAmount": total,
    //         "transactionList":
    //             FieldValue.arrayUnion([transactionModel.toJson()])
    //       })
    //     });
  }

  // Future<void> updateDriver(Driver driver, String userId) async {
  //   await driverCollection.doc(userId).update(driver.toJson());
  // }
  //
  // Future<void> updatePassengersConnectedWithDRiver(
  //     Passenger passenger, String userId) async {
  //   await driverCollection.doc(userId).update({
  //     "passengerList": FieldValue.arrayUnion([passenger.toJson()])
  //   });
  // }
  //
  // Future<void> updateDriverDetails(
  //     String startAddress,
  //     String endAddress,
  //     double startLat,
  //     double startLon,
  //     double endLat,
  //     double endLon,
  //     bool isStartDriving,
  //     String userId) async {
  //   await driverCollection.doc(userId).update({
  //     'start_address': startAddress,
  //     'end_address': endAddress,
  //     'driver_star_lat': startLat,
  //     'driver_star_lon': startLon,
  //     'driver_end_lat': endLat,
  //     'driver_end_lon': endLon,
  //     'isStartDrive': isStartDriving
  //   });
  // }
  //
  // Future<void> updateDriverStatus(bool isStartDriving, String userId) async {
  //   await driverCollection.doc(userId).update({'isStartDrive': isStartDriving});
  // }
  //
  // Future<void> updateDriverCurrentLocation(
  //     double startLat, double startLon, String userId) async {
  //   await driverCollection
  //       .doc(userId)
  //       .update({'driver_star_lat': startLat, 'driver_star_lon': startLon});
  // }
  //
  // Future<Driver> getDriverDetails(String userID) async {
  //   var docSnapshot = await driverCollection.doc(userID).get();
  //   Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
  //   Driver driver = Driver.fromJson(data);
  //   return driver;
  // }
  //

  //
  // Stream<QuerySnapshot> getAllDrivers() {
  //   return driverCollection.snapshots();
  // }
  //
  // Future<void> signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }
}
