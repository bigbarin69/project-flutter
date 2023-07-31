// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';

void main()=> runApp(MaterialApp(
  home: Home()

));



class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('5559852.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
             
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(40.0,30.0,0.0,0.0),
                  child: Text(
                    'akashic',
                    style: TextStyle(
                      fontFamily: 'Lily',
                      fontSize: 40.0,
                      color: Colors.white,
                      letterSpacing: 3.0
                      
                    ),
                    ),
                ),
              ),
              
              Container
              (
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: TextButton(
                onPressed: (){},
                style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Color.fromARGB(255, 82, 85, 123)),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ), 
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.23,
                  ),
                  )
                ),
              ),
                Container
              (
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: TextButton(
                onPressed: (){},
                style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Color.fromARGB(255, 82, 85, 123)),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ), 
                child: Text(
                  'Features',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.23,
                  ),
                  )
                ),
              ),
                Container
              (
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: TextButton(
                onPressed: (){},
                style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Color.fromARGB(255, 82, 85, 123)),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ), 
                child: Text(
                  'About',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.23,
                  ),
                  )
                ),
              ),
                Container
              (
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: TextButton(
                onPressed: (){},
                style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Color.fromARGB(255, 82, 85, 123)),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ), 
                child: Text(
                  'Service',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.23,
                  ),
                  )
                ),
              ),
                Container
              (
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: TextButton(
                onPressed: (){},
                style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Color.fromARGB(255, 82, 85, 123)),
                  foregroundColor: MaterialStatePropertyAll(Colors.white)
                ), 
                child: Text(
                  'Contact',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.23,
                  ),
                  )
                ),
              ),
              Container
              (
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: IconButton(
                icon: Icon(Icons.search),
                onPressed: (){},
                color: Colors.white,
                iconSize: 36.0,
                ),
              ),
              Container
              (
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                child: IconButton(
                icon: Icon(Icons.menu_open_outlined),
                onPressed: (){},
                color: Colors.white,
                iconSize: 38.0,
                ),
              ),
              
              
              
            ],
          ),  
         Row(
          children: [
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
          padding: EdgeInsets.fromLTRB(40.0, 120.0, 0.0, 0.0),
          child:  Text(
            'Welcome!',
            style: TextStyle(
              fontFamily: 'REM',
              fontSize: 56.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
            ),
         ),
        
          Container(
          padding: EdgeInsets.fromLTRB(40.0, 30.0, 20.0, 0.0),
          child:  Text(
            'Akashic is a free to use database app that you\ncan use to keep track of any and all books\nyouve read.Over 200,000 books and written material\nall in one location (real). Some more words to fill\nin the spaces so it doesnt look as empty. Maybe just\na bit more so that I can get rid of this hell. Sign up today!',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24.0,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
            ),
         ),
         Container(
          padding: EdgeInsets.fromLTRB(40.0, 30.0, 0.0, 0.0),
          child: ElevatedButton(
          onPressed: (){}, 
          child: Container(
            padding: EdgeInsets.all(8.0),
          child:  Text(
            'Sign in',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20.0,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
            ),
         ),
          ),
         )
          ],
         ),
         Padding(
          padding: EdgeInsets.fromLTRB(40.0,160.0,0.0,0.0),
          child: Container(
            width: 630.0,
            height: 320.0,
            padding: EdgeInsets.all(10.0),

            child: Align(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage('pngimage.png') ,
                )
            )
          ),
          )
         
          ],
         )     
        ],
      )
      ),
    );
  }
}
