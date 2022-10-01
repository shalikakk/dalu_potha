import 'package:dalu_potha/home_screen.dart';
import 'package:flutter/material.dart';

import '../auth/views/login.dart';
import '../auth/views/registerPage.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    // '/': (context) => WelcomePage(),
    '/sign-in': (context) => Login(),
    '/sign-up': (context) => Signup(),
  };
}
