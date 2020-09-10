import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/moor_database.dart';


import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Input measure'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _inputMeasure(context)),
          ],
        ));
  }

  Builder _inputMeasure(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
     final measure = Measure(id: null,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
              (1599721698 * 1000)), 
    temperature: 24.43,
    humidity: 55.46,
    pressure: 994.64,
    boxTemperature: 28.5,
    sentToFirebase: null);
     database.insertMeasure(measure);
  }
}
