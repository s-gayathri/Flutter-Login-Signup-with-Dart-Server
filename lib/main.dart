import 'package:flutter/material.dart';
import 'package:loginAndRegister/pages/login.dart';
import 'package:loginAndRegister/pages/profile.dart';
import 'package:loginAndRegister/pages/register.dart';

void main() => runApp(
      MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/profile': (context) => Profile()
        },
      ),
    );
