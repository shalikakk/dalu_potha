import 'package:dalu_potha/auth/model/customer_model.dart';
import 'package:dalu_potha/customers/customer_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../database.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  AddCustomerScreenState createState() {
    return AddCustomerScreenState();
  }
}

class AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNoController = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser?.email;
  final DataRepository repository = DataRepository();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Customer"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // Handles Form Validation for First Name
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Customer name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  controller: nameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // Handles Form Validation for Last Name
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Customer Address';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Customer Address'),
                  controller: addressController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  // Handles Form Validation for Last Name
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Customer Phone No';
                    } else if (value.length != 10) {
                      return 'Phone Number is incorrect';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(labelText: 'Customer Phone Number'),
                  controller: phoneNoController,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          Customer customer = Customer(
                              totalAmount: 0,
                              transactions: [],
                              customerName: nameController.text,
                              customerPhoneNo: phoneNoController.text,
                              customerAddress: addressController.text);
                          repository.addCustomer(customer).then((result) {
                            if (result == null) {
                              // Fluttertoast.showToast(
                              //     msg:
                              //         "Congratulation, Your account has been successfully created",
                              //     toastLength: Toast.LENGTH_LONG,
                              //     gravity: ToastGravity.BOTTOM,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.green,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CustomerList()));
                            } else {
                              // Fluttertoast.showToast(
                              //     msg: result,
                              //     toastLength: Toast.LENGTH_LONG,
                              //     gravity: ToastGravity.BOTTOM,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.red,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                            }
                          });
                        }
                      },
                      child: const Text(
                        'Add New Customer',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
