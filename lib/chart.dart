import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './main_drawer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:math';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

//TODO: zaimplementować dwie matody w klasie Measurment Class: toMap(), toJson() --> pierwsza to inputu do bazy, druga do ładowania do widoku

Future<MeasurementSet> fetchPost() async {
  print("Checking connectivity result");

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.wifi) {
    var wifiBSSID = await (Connectivity().getWifiBSSID());
    print(wifiBSSID);
    var wifiIP = await (Connectivity().getWifiIP());
    print(wifiIP);
    var wifiName = await (Connectivity().getWifiName());
    print(wifiName);
  }

  print("Making http request..");

  var getMeasuresUrl = "http://192.168.4.1/measure";
  final response = await http.get(getMeasuresUrl);
  if (response.statusCode == 200) {
    print(response.statusCode);
    print(response.body);
  } else {
    throw Exception('Failed to make get request');
  }
  return MeasurementSet.fromJson(json.decode(response.body));
}



class ChartScreen extends StatefulWidget {
  ChartScreen({Key key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final Connectivity _connectivity = Connectivity();
  Color _connectionStatus = Colors.red;
  var _connectionStatusText = '';
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  double _temperature = 0;
  double _humidity = 0;
  double _pressure = 0;
  Color color = Colors.redAccent[400];

  //TODO: implement on ESP32 decimal precision
  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void _printValues(Map map) {
    setState(() {
      _temperature = roundDouble(map['temperature'], 2);
      _humidity = roundDouble(map['humidity'], 2);
      _pressure = roundDouble(map['pressure'], 1);
    });
  }
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 18, height: 2);
    return Scaffold(
      appBar: AppBar(
        title: Text("Pomiary UL"),
      ),
      drawer: MainDrawer(),
      body: Column(children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      _roundedPhoto('assets/hive.jpg', _connectionStatus, 90.0)
                    ],
                  ),
                ])),
        Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      FaIcon(FontAwesomeIcons.temperatureHigh, color: color),
                      Text('$_temperature st.C', style: textStyle),
                      Text('Temperatura',
                          style: TextStyle(color: Colors.red[600])),
                    ],
                  ),
                  Column(
                    children: [
                      FaIcon(FontAwesomeIcons.tint, color: Colors.blue),
                      Text('$_humidity %', style: textStyle),
                      Text('Wilgotność',
                          style: TextStyle(color: Colors.blue[800])),
                    ],
                  ),
                  Column(
                    children: [
                      FaIcon(FontAwesomeIcons.tachometerAlt,
                          color: Colors.indigo[800]),
                      Text('$_pressure hPa', style: textStyle),
                      Text('Ciśnienie',
                          style: TextStyle(color: Colors.indigo[800])),
                    ],
                  ),
                  // Column(
                  //   children: [
                  //     FaIcon(FontAwesomeIcons.weightHanging,
                  //         color: Colors.grey[800]),
                  //     Text('0 kg', style: textStyle),
                  //     Text('Waga',
                  //         style: TextStyle(color: Colors.grey[800])),
                  //   ],
                  // ),
                ])),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var dataset = await fetchPost();
          print(dataset.toString());
          _printValues(dataset.toMap());
          
          // _printValues(dataset);
        },
        child: FaIcon(FontAwesomeIcons.download, color: Colors.grey[100]),
        backgroundColor: color,
      ),
    );
  }

  //   Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        String wifiName, wifiIP, wifiBSSID;
        try {
          wifiName = (await _connectivity.getWifiName()).toString();
          print(wifiName);
        } on PlatformException catch (e) {
          print(e.toString());

          wifiName = "Failed to get Wifi Name";
        }

        try {
          wifiIP = (await _connectivity.getWifiIP()).toString();
          print(wifiIP);
        } on PlatformException catch (e) {
          print(e.toString());

          wifiName = "Failed to get Wifi IP";
        }
        setState(() {
          if(wifiBSSID == '02:00:00:00:00:00'){
          _connectionStatus = Colors.orange;
          } else{
          _connectionStatus = Colors.greenAccent[400];
          }
        });
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = Colors.tealAccent);
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = Colors.red[400]);
        break;
      default:
        setState(() => _connectionStatus = Colors.grey[30]);
        break;
    }
  }

}

//MeasurmentSet class contains parameters downloaded from hive.
class MeasurementSet {
  var temperature;
  var humidity;
  var pressure;

  MeasurementSet({this.temperature, this.humidity, this.pressure});

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'pressure': pressure,
      'humidity': humidity,
    };
  }

  //Convert a MeasurmentSet into a Map. Keys correspond to database columns.
  factory MeasurementSet.fromJson(Map<String, dynamic> json) {
    return MeasurementSet(
      temperature: json['temperature'],
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }

  @override
  String toString() {
    return 'MeasurmentSet{temperature: $temperature, name: $humidity, age: $pressure}';
  }
}

class Beehive {
  var serialNumber;
  var ssid;
  var currentPass;
  var defaultPass;
  var hasScale;
  var productionTime;
  var uid;

  Beehive({this.productionTime,
          this.currentPass,
          this.ssid,
          this.defaultPass,
          this.hasScale,
          this.serialNumber,
          this.uid});
}

Container _roundedPhoto(var assetPath, Color connStatus, var size) =>
    Container(
      width: size,
      height: size,
      margin: EdgeInsets.only(left: 15, bottom: 20),
      decoration: BoxDecoration(
          color: connStatus,
          image: new DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: connStatus,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: connStatus,
              blurRadius: 7,
              spreadRadius: 2,
            )
          ]),
    );