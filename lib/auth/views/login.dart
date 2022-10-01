import 'package:dalu_potha/auth/model/busines_model.dart';
import 'package:dalu_potha/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database.dart';
import '../authentication.dart';
import 'registerPage.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            SizedBox(height: 80),
            // logo
            Column(
              children: const [
                FlutterLogo(
                  size: 55,
                ),
                SizedBox(height: 50),
                Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),

            SizedBox(
              height: 50,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoginForm(),
            ),

            SizedBox(height: 20),

            Row(
              children: <Widget>[
                SizedBox(width: 30),
                Text('New here ? ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, '/signup');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Text('Get Registered Now!!',
                      style: TextStyle(fontSize: 20, color: Colors.blue)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormPassengerState createState() => _LoginFormPassengerState();
}

class _LoginFormPassengerState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email = "lahiru@gmail.com";
  String? password = "sanju.ad";

  bool _obscureText = true;

  final DataRepository repository = DataRepository();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> saveUserId(String _userID) async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      prefs.setString('userId', _userID).then((bool success) {
        return counter;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Login as Passenger',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          // email
          TextFormField(
            // initialValue: 'Input text',
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100.0),
                ),
              ),
            ),
            validator: RequiredValidator(errorText: 'Email is required'),
            onSaved: (val) {
              email = val;
            },
          ),
          SizedBox(
            height: 20,
          ),

          // password
          TextFormField(
            // initialValue: 'Input text',
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
              ),
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
            obscureText: _obscureText,
            onSaved: (val) {
              password = val;
            },
            validator: RequiredValidator(errorText: 'password is required'),
          ),

          SizedBox(height: 30),

          SizedBox(
            height: 54,
            width: 184,
            child: ElevatedButton(
              onPressed: () {
                // Respond to button press

                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  Auth()
                      .signIn(email: email!, password: password!)
                      .then((result) {
                    if (result!.length < 40) {
                      saveUserId(result);
                      // repository
                      //     .getPassengerDetails(result);
                      // then((Business business) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    email: result,
                                  )));
                      // }
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
