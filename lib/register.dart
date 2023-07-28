import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/main.dart';

void main() => runApp(const MaterialApp(
      home: MyRegister(),
      debugShowCheckedModeBanner: false,
    ));

createregister(String login, String pass, String fullname, String email,
    String phoneno) async {
  var map = <String, dynamic>{};
  map['username'] = login;
  map['password'] = pass;
  map['fullname'] = fullname;
  map['email'] = email;
  map['phone'] = phoneno;

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
  final myFullname = TextEditingController();
  final myEmail = TextEditingController();
  final myPhoneno = TextEditingController();

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
                  controller: myFullname,
                  decoration: const InputDecoration(hintText: 'Full Name'),
                ),
                TextField(
                  controller: myUsername,
                  decoration: const InputDecoration(hintText: 'Username'),
                ),
                TextField(
                  controller: myPassword,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                TextField(
                  controller: myEmail,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                TextField(
                  controller: myPhoneno,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Phone Number'),
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        createregister(myUsername.text, myPassword.text,
                            myFullname.text, myEmail.text, myPhoneno.text);
                      });
                    },
                    child: const Text('Register'))
              ]),
        ),
      ),
    );
  }
}
