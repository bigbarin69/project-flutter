import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/main.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(
      home: Dashboard(),
      debugShowCheckedModeBanner: false,
    ));

Future<String?> getsavedusername() async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString('username');
  return value;
}

Future<List<Books>> getbooks() async {
  var map = <String?, dynamic>{};
  Future<String?> futureusername = getsavedusername();
  String? savedusername = await futureusername;
  map['username'] = savedusername;

  http.Response response = await http.post(
    Uri.parse('http://127.0.0.1:8000/get-books'),
    body: map,
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Books.fromJson(data)).toList();
  } else {
    throw Exception('Error!');
  }
}

class Books {
  final int id;
  final String username;
  final String bookname;
  final String rating;

  const Books(
      {required this.id,
      required this.username,
      required this.bookname,
      required this.rating});

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      id: json['id_no'],
      username: json['username'],
      bookname: json['book_name'],
      rating: json['rating'],
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<List<Books>> books = getbooks();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Dashboard'),
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
            padding: const EdgeInsets.all(25.0),
            alignment: Alignment.topCenter,
            child: Center(child: userbooks()),
          )),
    );
  }

  FutureBuilder<List<Books>> userbooks() {
    return FutureBuilder<List<Books>>(
      future: books,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  child: ListTile(
                    tileColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    title: Text(snapshot.data![index].bookname),
                    subtitle: Text('Rating : ${snapshot.data![index].rating}'),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return const Text(
            'Please Log In.',
            style: TextStyle(
              fontSize: 30.0,
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
