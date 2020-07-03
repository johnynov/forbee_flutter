import 'package:flutter/material.dart';
import 'main_drawer.dart';

String nUsername = "";

class Apiarist extends StatefulWidget {
  @override
  _ApiaristState createState() => _ApiaristState();
}

class _ApiaristState extends State<Apiarist> {
  TextEditingController etUsername = new TextEditingController();

  // String nUsername = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ja, pszczelarz'),
      ),
      drawer: MainDrawer(),
      body: Form(
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
              ),

              Text('Identyfikacja pszczelarza',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),

              TextFormField(
                controller: etUsername,
                decoration: InputDecoration(
                    hintText: 'Podaj swoje imię'
                ),
              ),

             

              Container(
                alignment: Alignment.center,
                child: MaterialButton(onPressed: () {
                  setState(() {
                    nUsername = etUsername.text;
                  });
                },
                  color: Colors.orange,
                  textColor: Colors.white,
                  child: Text('Zatwierdzam'),
                ),
              ),

              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Text("Twoje imię:  " + nUsername)
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}