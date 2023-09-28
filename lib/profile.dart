import 'dart:convert';
import 'package:akashic/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(
      home: Profile(),
      debugShowCheckedModeBanner: false,
    ));

Future<String?> getsavedusername() async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString('username');
  return value;
}

Future<Userprofile> userdetails() async {
  var map = <String?, dynamic>{};
  Future<String?> futureusername = getsavedusername();
  String? savedusername = await futureusername;
  map['username'] = savedusername;

  http.Response response = await http.post(
    Uri.parse('https://akashic-api.prathikp.tech/profile'),
    body: map,
  );

  if (response.statusCode == 200) {
    return Userprofile.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error!');
  }
}

class Userprofile {
  final String username;
  final String fullname;
  final String password;
  final String email;
  final int phone;

  const Userprofile(
      {required this.username,
      required this.fullname,
      required this.password,
      required this.email,
      required this.phone});

  factory Userprofile.fromJson(Map<String, dynamic> json) {
    return Userprofile(
        username: json['username'],
        fullname: json['fullname'],
        password: json['password'],
        email: json['email'],
        phone: json['phone']);
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Userprofile> userprofile = userdetails();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Interbold',
        scaffoldBackgroundColor: const Color.fromARGB(175, 104, 208, 189),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: const Color.fromARGB(178, 70, 164, 196),
          titleSpacing: 20.0,
          toolbarHeight: 70.0,
          centerTitle: true,
          leading: Row(
            children: <Widget>[
              const SizedBox(width: 20.0),
              Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          leadingWidth: 100.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            padding: const EdgeInsets.only(top: 40.0),
            alignment: Alignment.center,
            child: profilebuilder(),
          ),
        ),
      ),
    );
  }

  FutureBuilder<Userprofile> profilebuilder() {
    return FutureBuilder<Userprofile>(
        future: userprofile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Full Name',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 78, 77, 77)),
                ),
                Container(
                  width: 750.0,
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  child: Text(
                    snapshot.data!.fullname,
                    style: const TextStyle(fontSize: 25.0),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Username',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 78, 77, 77)),
                ),
                Container(
                  width: 750.0,
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  child: Text(
                    snapshot.data!.username,
                    style: const TextStyle(fontSize: 25.0),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Password',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 78, 77, 77)),
                ),
                Container(
                  width: 750.0,
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  child: Text(
                    snapshot.data!.password,
                    style: const TextStyle(fontSize: 25.0),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 78, 77, 77)),
                ),
                Container(
                  width: 750.0,
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  child: Text(
                    snapshot.data!.email,
                    style: const TextStyle(fontSize: 25.0),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Phone Number',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 78, 77, 77)),
                ),
                Container(
                  width: 750.0,
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0))),
                  child: Text(
                    '${snapshot.data!.phone}',
                    style: const TextStyle(fontSize: 25.0),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return const Text(
              'Please Log in!',
              style: TextStyle(
                fontSize: 30.0,
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
