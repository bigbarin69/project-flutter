import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/main.dart';

void main() => runApp(const MaterialApp(
      home: MyRegister(),
      debugShowCheckedModeBanner: false,
    ));

createregister(String login, String pass) async {
  var map = <String, dynamic>{};
  map['username'] = login;
  map['password'] = pass;

  http.Response response = await http.post(
    Uri.parse('http://127.0.0.1:8000/register'),
    body: map,
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final myUsername = TextEditingController();
  final myPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Register',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Test Register'),
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
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        createregister(myUsername.text, myPassword.text);
                      });
                    },
                    child: const Text('Send data'))
              ]),
        ),
      ),
    );
  }
}
