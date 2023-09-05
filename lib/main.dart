import 'package:flutter/material.dart';
import 'package:akashic/login.dart';
import 'package:akashic/register.dart';
import 'package:akashic/dashboard.dart';
import 'package:akashic/profile.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyArw_8iuqvK6lurIXMyBfIacoU5pymRv-s",
          authDomain: "fluttast-app.firebaseapp.com",
          projectId: "fluttast-app",
          storageBucket: "fluttast-app.appspot.com",
          messagingSenderId: "154015637448",
          appId: "1:154015637448:web:34ec9e4b2e88e62f862afd",
          measurementId: "G-JM1M146BT4"));
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akashic',
      theme: ThemeData(
        fontFamily: 'Interbold',
        scaffoldBackgroundColor: const Color.fromARGB(175, 104, 208, 189),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(178, 70, 164, 196),
                  titleSpacing: 20.0,
                  toolbarHeight: 70.0,
                  title: const Text(
                    'Akashic',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Lily',
                      letterSpacing: 1.5,
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0))),
                          child: TextButton(
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
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0))),
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyRegister()));
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0))),
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Dashboard()));
                              },
                              child: const Text(
                                'Dashboard',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0))),
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Profile()));
                              },
                              child: const Text(
                                'Profile',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                      ],
                    )
                  ],
                ),
                body: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(55.0, 20.0, 0, 10.0),
                          child: const Text(
                            'Welcome!',
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(55.0, 20.0, 0, 10.0),
                          child: const Text(
                            'Akashic is a free to use database app that you\ncan use to keep track of any and all books\nyouve read.Over 200,000 books and written material\nall in one location. Sign up today to get access\nto a mega-library at the cost of free!\n',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
