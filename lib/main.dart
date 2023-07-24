import 'package:flutter/material.dart';
import 'package:app/login.dart';
import 'package:app/register.dart';

void main() => runApp(const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
        title: const Text('Home Page'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyLogin()));
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyRegister()));
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      )),
    );
  }
}
