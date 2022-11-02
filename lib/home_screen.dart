import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalu_potha/Transactions/transaction_list_screen.dart';
import 'package:dalu_potha/customers/customer_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/model/customer_model.dart';
import 'database.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataRepository repository = DataRepository();
  String email = "q@gmail.com";

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    email = prefs.getString('user_email') ?? "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getAllCustomers(widget.email),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.deepPurple,
              ));

            return _buildList(context, snapshot.data?.docs ?? []);
          }),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              // <-- SEE HERE
              accountName: Text(
                "Pinkesh Darji",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "pinkesh.earth@gmail.com",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: Icon(Icons.energy_savings_leaf),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: const Text('Customers'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CustomerList()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

// 3
  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final customer = Customer.fromSnapshot(snapshot);

    return MaterialButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TransactionListScreen(
                  customer: customer,
                  email: widget.email,
                )));
      },
      child: Card(
        child: ListTile(
          title: Text(customer.customerName ?? ""),
          subtitle: Text(customer.customerAddress ?? ""),
        ),
      ),
    );
  }
}
