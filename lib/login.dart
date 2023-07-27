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

  // @override
  // void initState() {
  //   super.initState();
  //   futureLogin = createlogin();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Login Page'),
            leading: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyApp()));
              },
              child: const Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: (futureLogin == null) ? buildColumn() : buildFutureBuilder(),
          )),
    );
  }

  Column buildColumn() {
    return Column(
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
        ElevatedButton(
            onPressed: () {
              setState(() {
                futureLogin = createlogin(myUsername.text, myPassword.text);
              });
            },
            child: const Text('Check Data'))
      ],
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
