import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/screens/home/home.dart';
import 'package:flutter_app/screens/register_smoking_area.dart';
import 'package:flutter_app/screens/services/auth.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        initialData: null,
        value: AuthService().user,
        child: MaterialApp(
            initialRoute: '/',
            theme: ThemeData(
              fontFamily: "NanumSquareRoundB",
            ),
            routes: {
              '/': (context) => MainScreen(),
              '/register_smoking_area': (context) =>
                  RegisterSmokingAreaScreen(),
            }));
  }
}

