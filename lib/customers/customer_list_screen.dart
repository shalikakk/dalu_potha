import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalu_potha/customers/add_cistomer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/model/customer_model.dart';
import '../database.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final DataRepository repository = DataRepository();

  var currentUser = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getAllCustomers(currentUser!),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.deepPurple,
              ));

            return _buildList(context, snapshot.data?.docs ?? []);
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddCustomerScreen()));
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      // 2
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

// 3
  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    // 4
    final customer = Customer.fromSnapshot(snapshot);

    return MaterialButton(
      onPressed: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => DriverDetails(driver: driver)));
      },
      child: Card(
        child: ListTile(
            title: Text(customer.customerName ?? ""),
            subtitle: Text(customer.customerAddress ?? "")),
      ),
    );
  }
}
