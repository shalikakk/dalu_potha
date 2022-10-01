import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../database.dart';
import '../authentication.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              // logo
              Icon(
                Icons.drive_eta,
                size: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 25),
              const Text(
                'Register as Driver!',
                style: const TextStyle(fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SignupForm(),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Already here  ?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(' Get Logged in Now!',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.blue)),
                  )
                ],
              ),
            ],
          ),

          //passenger
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              // logo
              Icon(
                Icons.person,
                size: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(height: 25),
              const Text(
                'Register as Passenger!',
                style: const TextStyle(fontSize: 24),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SignupForm(),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Already here  ?',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(' Get Logged in Now!',
                        style: TextStyle(fontSize: 20, color: Colors.blue)),
                  )
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }

  Container buildLogo() {
    return Container(
      height: 80,
      width: 80,
      decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(10)),
          color: Colors.blue),
      child: const Center(
        child: const Text(
          "T",
          style: const TextStyle(color: Colors.white, fontSize: 60.0),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {

  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}



class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? ownerName;
  String? businessName;
  String? businessPhoneNo;
  String? businessAddress;
  bool _obscureText = false;

  bool agree = false;

  final pass = new TextEditingController();

  final DataRepository repository = DataRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(100.0),
      ),
    );

    var space = const SizedBox(height: 10);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Owner name',
              prefixIcon: const Icon(Icons.account_circle),
              border: border,
            ),
            onSaved: (val) {
              ownerName = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Your name';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Business name',
              prefixIcon: const Icon(Icons.account_circle),
              border: border,
            ),
            onSaved: (val) {
              businessName = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Your Business name';
              }
              return null;
            },
          ),
          space,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Business Address',
              prefixIcon: const Icon(Icons.account_circle),
              border: border,
            ),
            onSaved: (val) {
              businessAddress = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Your Business Address';
              }
              return null;
            },
          ),
          space,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.account_circle),
              border: border,
            ),
            onSaved: (val) {
              businessPhoneNo = val;
            },
            validator: (value) {
              if (value?.length != 10)
                return 'Mobile Number must be of 10 digit';
              else
                return null;
            },
          ),

          space,
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Email',
                border: border),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),

          space,

          // password
          TextFormField(
            controller: pass,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: border,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            onSaved: (val) {
              password = val;
            },
            obscureText: !_obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          space,
          // confirm passwords
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              border: border,
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'password not match';
              }
              return null;
            },
          ),
          space,
          // name

          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (_) {
                  setState(() {
                    agree = !agree;
                  });
                },
                value: agree,
              ),
              const Flexible(
                child: const Text(
                    'By creating account, I agree to Terms & Conditions and Privacy Policy.'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          // signUP button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                    Auth()
                        .signUpBusiness(email!, password!, ownerName!, businessName!,businessPhoneNo!,businessAddress!)
                        .then((result) {
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
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
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
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: const Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}
