import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:akashic/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(
      home: MyRegister(),
      debugShowCheckedModeBanner: false,
    ));

void savedusername(String username) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('username', username);
}

Future<Register> createregister(String login, String pass, String fullname,
    String email, String phoneno) async {
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
    savedusername(login);
    return Register.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Register!');
  }
}

class Register {
  final String username;

  const Register({required this.username});

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      username: json['username'],
    );
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
  Future<Register>? futureregister;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Register',
        theme: ThemeData(
          fontFamily: 'Interbold',
          scaffoldBackgroundColor: const Color.fromARGB(175, 104, 208, 189),
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(178, 70, 164, 196),
              centerTitle: true,
              titleSpacing: 20.0,
              toolbarHeight: 70.0,
              title: const Text(
                'Register',
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
            body: Center(
              child: Column(children: <Widget>[
                const SizedBox(
                  height: 60.0,
                ),
                const Text(
                  'Create an account now!',
                  style: TextStyle(
                      fontSize: 40.0, color: Color.fromARGB(255, 62, 82, 93)),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: (futureregister == null)
                      ? registercont()
                      : registerreturn(),
                ),
              ]),
            )));
  }

  Container registercont() {
    return Container(
      height: 430.0,
      width: 400.0,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 3.0),
          borderRadius: const BorderRadius.all(Radius.circular(15.0))),
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
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 10, 187, 161)),
                onPressed: () {
                  setState(() {
                    futureregister = createregister(
                        myUsername.text,
                        myPassword.text,
                        myFullname.text,
                        myEmail.text,
                        myPhoneno.text);
                  });
                },
                child: const Text('Register'))
          ]),
    );
  }

  FutureBuilder<Register> registerreturn() {
    return FutureBuilder<Register>(
      future: futureregister,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 100.0),
            child: Text(
              '${snapshot.data?.username} signed in!',
              style: const TextStyle(fontSize: 30),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
