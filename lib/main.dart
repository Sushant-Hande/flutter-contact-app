import 'dart:ffi';

import 'package:contact_app/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model/contact.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Contact> contactList = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final theme = ThemeData.light();
    return MaterialApp(
        title: 'Photos Keyboard',
        themeMode: ThemeMode.light,
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.black,
            secondary: Colors.green[700],
            background: Colors.white,
            brightness: Brightness.light,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Dashboard());
  }

}