import 'dart:convert';
import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:akashic/main.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Interbold',
        scaffoldBackgroundColor: const Color.fromARGB(175, 104, 208, 189),
      ),
      title: 'Dashboard',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(178, 70, 164, 196),
            centerTitle: true,
            title: const Text(
              'Dashboard',
              style: TextStyle(fontSize: 25.0),
            ),
            titleSpacing: 20.0,
            toolbarHeight: 70.0,
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
                                  builder: (context) =>
                                      const Dashboardentry()));
                        },
                        child: const Text(
                          'Add Books',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  const SizedBox(
                    width: 20.0,
                  )
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
                return Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.fromLTRB(17.0, 5.0, 17.0, 5.0),
                    tileColor: const Color.fromRGBO(107, 148, 168, 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    title: Text(
                      snapshot.data![index].bookname,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                    subtitle: Text('Rating : ${snapshot.data![index].rating}'),
                    trailing: Text(
                      snapshot.data![index].status,
                      style: const TextStyle(fontSize: 17.0),
                    ),
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

// ########################################################################################################################

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
      theme: ThemeData(
        fontFamily: 'Interbold',
        scaffoldBackgroundColor: const Color.fromARGB(175, 104, 208, 189),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Add Books'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(178, 70, 164, 196),
            titleSpacing: 20.0,
            toolbarHeight: 70.0,
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
                              builder: (context) => const Dashboard()));
                    },
                    child: const Text(
                      'Dashboard',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            leadingWidth: 150.0,
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
        const SizedBox(
          height: 30.0,
        ),
        const Text(
          'Add your favourite books',
          style: TextStyle(
            fontSize: 30.0,
            color: Color.fromRGBO(57, 86, 101, 1),
          ),
        ),
        const SizedBox(
          height: 45.0,
        ),
        Container(
          padding: const EdgeInsets.only(left: 11.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Bookname',
            style: TextStyle(
                fontSize: 22.0, color: Color.fromARGB(255, 106, 104, 104)),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
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
          padding: const EdgeInsets.only(left: 11.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Rating',
            style: TextStyle(
                fontSize: 22.0, color: Color.fromARGB(255, 106, 104, 104)),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
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
          padding: const EdgeInsets.only(left: 11.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Status',
            style: TextStyle(
                fontSize: 22.0, color: Color.fromARGB(255, 106, 104, 104)),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
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
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 10, 187, 161)),
            onPressed: () {
              setState(() {
                newentry =
                    sendbooks(myBookname.text, myRating.text, selectedstatus!);
              });
            },
            child: const Text('Add Book')),
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
            style: TextStyle(fontSize: 30),
          );
        } else if (snapshot.hasError) {
          return const Text(
            'Please Log in!',
            style: TextStyle(fontSize: 30.0),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
