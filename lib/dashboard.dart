import 'dart:convert';
import 'dart:async';
import 'dart:js_interop';
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
  final String status;

  const Books(
      {required this.id,
      required this.username,
      required this.bookname,
      required this.rating,
      required this.status});

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
        id: json['id_no'],
        username: json['username'],
        bookname: json['book_name'],
        rating: json['rating'],
        status: json['status']);
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
            actions: <Widget>[
              Row(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Dashboardentry()));
                      },
                      child: const Text(
                        'Add Books',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )
            ],
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
                    trailing: Text(snapshot.data![index].status),
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

Future<Books> sendbooks(String bookname, String rating, String status) async {
  var map = <String?, dynamic>{};
  Future<String?> futureusername = getsavedusername();
  String? savedusername = await futureusername;
  map['username'] = savedusername;
  map['bookname'] = bookname;
  map['rating'] = rating;
  map['status'] = status;

  http.Response response = await http.post(
    Uri.parse('http://127.0.0.1:8000/add-books'),
    body: map,
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Error!');
  }
}

class Dashboardentry extends StatefulWidget {
  const Dashboardentry({super.key});

  @override
  State<Dashboardentry> createState() => _DashboardentryState();
}

class _DashboardentryState extends State<Dashboardentry> {
  final myBookname = TextEditingController();
  final myRating = TextEditingController();
  final myStatus = TextEditingController();
  List<String> list = <String>[
    'Plan to read',
    'Completed',
    'Currently Reading',
    'Paused',
    'Dropped'
  ];
  String? selectedstatus;
  Future<Books>? newentry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Books',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Add Books'),
            centerTitle: true,
            leading: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Dashboard()));
                },
                child: const Text(
                  'Back',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(150.0, 35.0, 150.0, 35.0),
            child: (newentry == null) ? addingbooks() : addedbooks(),
          )),
    );
  }

  Column addingbooks() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(5.0))),
          child: TextField(
            controller: myBookname,
            decoration:
                const InputDecoration(hintText: 'Harry Botter, Softy Boys ...'),
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(5.0))),
          child: TextField(
            controller: myRating,
            decoration: const InputDecoration(hintText: '1...10'),
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            child: DropdownButton<String>(
                isExpanded: true,
                value: selectedstatus,
                hint: const Text('Select your preferred status'),
                onChanged: (String? value) {
                  setState(() {
                    selectedstatus = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList())),
        const SizedBox(
          height: 25.0,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                newentry =
                    sendbooks(myBookname.text, myRating.text, selectedstatus!);
              });
            },
            child: const Text('Submit Book')),
      ],
    );
  }

  FutureBuilder<Books> addedbooks() {
    return FutureBuilder<Books>(
      future: newentry,
      builder: (context, snapshot) {
        if (snapshot.isDefinedAndNotNull) {
          return const Text(
            'Book Entered!',
            style: TextStyle(fontSize: 20),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
