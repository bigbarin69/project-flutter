import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:app/register.dart';
import 'package:app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(
      home: MyLogin(),
      debugShowCheckedModeBanner: false,
    ));

void savedusername(String username) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('username', username);
}

Future<Login> createlogin(String username, String password) async {
  var map = <String, dynamic>{};
  map['username'] = username;
  map['password'] = password;

  http.Response response = await http.post(
    Uri.parse('http://127.0.0.1:8000/login'),
    body: map,
  );
  if (response.statusCode == 200) {
    savedusername(username);
    return Login.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Login {
  final String username;
  final String password;

  const Login({required this.username, required this.password});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      username: json['username'],
      password: json['password'],
    );
  }
}

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLogin();
}

class _MyLogin extends State<MyLogin> {
  final myUsername = TextEditingController();
  final myPassword = TextEditingController();
  Future<Login>? futureLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Interbold',
        scaffoldBackgroundColor: const Color.fromARGB(175, 104, 208, 189),
      ),
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(178, 70, 164, 196),
            titleSpacing: 20.0,
            toolbarHeight: 70.0,
            centerTitle: true,
            title: const Text(
              'Login Page',
              style: TextStyle(fontSize: 25.0),
            ),
            leading: Row(
              children: <Widget>[
                const SizedBox(width: 20.0),
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
                              builder: (context) => const MyApp()));
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
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: (futureLogin == null) ? buildColumn() : buildFutureBuilder(),
          )),
    );
  }

  Container buildColumn() {
    return Container(
      height: 400.0,
      width: 380.0,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 3.0),
          borderRadius: const BorderRadius.all(Radius.circular(15.0))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: myUsername,
            decoration: const InputDecoration(hintText: 'Username'),
          ),
          TextField(
            controller: myPassword,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          const SizedBox(
            height: 30.0,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 187, 161)),
              onPressed: () {
                setState(() {
                  futureLogin = createlogin(myUsername.text, myPassword.text);
                });
              },
              child: const Text(
                'Log In',
                style: TextStyle(),
              ))
        ],
      ),
    );
  }

  FutureBuilder<Login> buildFutureBuilder() {
    return FutureBuilder<Login>(
      future: futureLogin,
      builder: (context, snapshot) {
        if (snapshot.isDefinedAndNotNull) {
          return Text(
            '${myUsername.text} logged in!',
            style: const TextStyle(fontSize: 20),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
