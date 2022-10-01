import 'package:dalu_potha/auth/views/login.dart';
import 'package:dalu_potha/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/authentication.dart';
import 'common/get_routes.dart';
import 'database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: routePage(),
    );
  }
}

class routePage extends StatefulWidget {
  @override
  routePageState createState() => routePageState();
}

class routePageState extends State<routePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //bool isLoggedin = false;
  String email = "q@gmail.com";
  var myFuture;
  @override
  void initState() {
    super.initState();
    // myFuture = Provider.of<DataRepository>(context).fetchAlbum();
    //
    // _auth.authStateChanges().listen((User? user) async {
    //   if (user != null) {
    //     print(user.email);
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     prefs.setString('user_email', user.email!);
    //     setState(() {
    //       email = user.email!;
    //       isLoggedin = true;
    //     });
    //   } else {
    //     setState(() {
    //       isLoggedin = false;
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser?.email;
    return (currentUser != null)
        ? HomeScreen(
            email: currentUser,
          )
        : Login();
  }
}
