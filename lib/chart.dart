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
import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

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

  var getMeasuresUrl = "http://192.168.4.1/measures/now";
  final response = await http.get(getMeasuresUrl);
  if (response.statusCode == 200) {
    print(response.statusCode);
    print(response.body);
  } else {
    throw Exception('Failed to make get request');
  }
  return MeasurementSet.fromString(response.body);
}

Future<String> setToSleep() async {
  print("Making GET http request..");

  var getMeasuresUrl = "http://192.168.4.1/sleep";
  final response = await http.get(getMeasuresUrl);
  if (response.statusCode == 200) {
    print('Setting to sleep');
    return 'Moduł uśpiony, zzz...';
  } else {
    throw Exception('Failed to make get request');
    return null;
  }
}

Future<String> deleteMeasuresFile() async {
  print("Making GET http request..");

  var getMeasuresUrl = "http://192.168.4.1/measures/delete";
  final response = await http.get(getMeasuresUrl);
  if (response.statusCode == 200) {
    return 'Pomiary pogrzebane żywcem.';
  } else {
    throw Exception('Failed to make get request');
    return null;
  }
}

String mapParameters(Map<dynamic, dynamic> map){
  String paramstring;
  map.forEach((k,v) => paramstring += ('?' + k.toString() + '=' + v.toString()));
  return paramstring;
}

Future<String> syncTime() async {
  print("Making POST http request..");
  var url = "http://192.168.4.1/clock/set";
  var ms = (new DateTime.now()).millisecondsSinceEpoch;
  String time = (ms / 1000 + 3600*2).round().toString();
  String u = url + "?time=" + time;
  
  http.Response response = await http.post(u);
  if (response.statusCode == 200) {
    return "Czas zsynchronizowany";
  } else {
    throw Exception('Failed to make get request');
    return "null";
  }
}


class ChartScreen extends StatefulWidget {
  ChartScreen({Key key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final Connectivity _connectivity = Connectivity();
  Color _connectionStatus = Colors.red;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String _time = 'Czas pomiaru';
  String _temperature = '?';
  String _humidity = '?';
  String _pressure = '?';
  Color color = Colors.redAccent[400];

  //TODO: implement on ESP32 decimal precision
  double roundDouble(String value, int places) {
    double mod = pow(10.0, places);
    return ((double.parse(value) * mod).round().toDouble() / mod);
  }

  void _printValues(Map map) {
    setState(() {
      _temperature = map['tempBME'];
      _humidity = map['humBME'];
      _pressure = map['pressBME'];
      _time = map['time'];
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  List<bool> _selections1 = List.generate(3, (_) => false);
  List<bool> _selections2 = List.generate(4, (_) => false);

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 18, height: 2);
    return Scaffold(
        appBar: AppBar(
          title: Text("Pomiary UL"),
        ),
        drawer: MainDrawer(),
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          _roundedPhoto(
                              'assets/hive.jpg', _connectionStatus, 100.0)
                        ],
                      ),
                    ])),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Text('$_time ',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 200),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          FaIcon(FontAwesomeIcons.temperatureHigh,
                              color: color),
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
            Builder(
              builder: (context) {
                return  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width - 60,
                    height: 40.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(13.0)),
                    child: (RaisedButton(
                      onPressed: () async {


                        var dataset = await fetchPost();
                        print(dataset.toString());
                        _printValues(dataset.toMap());

                        final snackBar = SnackBar(
                          content: Row(children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 20),
                            Expanded(child: Text('Pobrano pomiar')),
                            ]));
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: const Text('Szybki pomiar',
                          style: TextStyle(fontSize: 14)),
                      color: Colors.green,
                      textColor: Colors.white,
                    )));
              },
            ),
            Builder(
              builder: (context) {
                return ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width - 60,
                    height: 40.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(13.0)),
                    child: (RaisedButton(
                      onPressed: () async {
                        String reponse = await setToSleep();
                        final snackBar = SnackBar(
                          content: Row(children: [
                            FaIcon(FontAwesomeIcons.moon, color: Colors.white),
                            SizedBox(width: 20),
                            Expanded(child: Text(reponse))
                          ]));
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child:
                          Text('Uśpij moduł', style: TextStyle(fontSize: 14)),
                      color: Colors.blue[800],
                      textColor: Colors.white,
                    )));
              },
            ),
            Container(
              margin: EdgeInsets.only(right: 30, left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Builder(
                builder: (context) {
                  return ButtonTheme(
                      minWidth:  (MediaQuery.of(context).size.width- 60)/2  -10,
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(13.0)),
                      child: (RaisedButton(
                        onPressed: () async {
                          String reponse = await deleteMeasuresFile();
                          final snackBar = SnackBar(
                            content: Row(children: [
                              FaIcon(FontAwesomeIcons.skull, color: Colors.white),
                              SizedBox(width: 20),
                              Expanded(child: Text(reponse))
                            ]),
                            // backgroundColor: Colors.black45,
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        },
                        child:
                            Text('Usuń pomiary', style: TextStyle(fontSize: 14)),
                        color: Colors.pinkAccent,
                        textColor: Colors.white,
                      )));
                },
              ),
              Builder(
                builder: (context) {
                  return ButtonTheme(
                      minWidth: (MediaQuery.of(context).size.width- 60)/2 -10,
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(13.0)),
                      child: (RaisedButton(
                        onPressed: () async {
                          String reponse = await syncTime();
                          final snackBar = SnackBar(
                            content: Row(children: [
                              Icon(Icons.av_timer, color:Colors.white),
                              SizedBox(width: 20),
                              Expanded(child: Text(reponse))
                            ])
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        },
                        child:
                            Text('Synchronizuj czas', style: TextStyle(fontSize: 14)),
                        color: Colors.green,
                        textColor: Colors.white,
                      )));
                },
              )
              ],),
            )
          ],
        ));
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
          if (wifiBSSID == '02:00:00:00:00:00') {
            _connectionStatus = Colors.orange;
          } else {
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
  var time;
  var tempBME;
  var pressBME;
  var humBME;
  var tempRTC;

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'tempBME': tempBME,
      'pressBME': pressBME,
      'humBME': humBME,
      'tempRTC': tempRTC,
    };
  }

  MeasurementSet(
      {this.time, this.tempBME, this.pressBME, this.humBME, this.tempRTC});

  //Convert Measure String to results
  factory MeasurementSet.fromString(String string) {
    var array = string.split(';');
    return MeasurementSet(
        time: DateFormat('HH:mm:ss dd/MMM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(int.parse(array[0]) * 1000)
                .toUtc()),
        tempBME: array[1],
        humBME: array[2],
        pressBME: array[3],
        tempRTC: array[4]);
  }

  // @override
  // String toString() {
  //   return 'MeasurmentSet{Time: $time, : $, age: $pressure}';
  // }
}

class Beehive {
  var serialNumber;
  var ssid;
  var currentPass;
  var defaultPass;
  var hasScale;
  var productionTime;
  var uid;

  Beehive(
      {this.productionTime,
      this.currentPass,
      this.ssid,
      this.defaultPass,
      this.hasScale,
      this.serialNumber,
      this.uid});
}

Container _roundedPhoto(var assetPath, Color connStatus, var size) => Container(
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
