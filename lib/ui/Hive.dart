import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forbee/ui/charts.dart';
import 'package:forbee/ui/measures.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'main_drawer.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import '../widgets/httpMethods.dart';
import 'package:vibration/vibration.dart';
import 'userAccount.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:developer';
import 'package:wifi/wifi.dart';

// import 'package:intl/date_symbol_data_local.dart';

import 'package:provider/provider.dart';
import '../data/moor_database.dart';

//TODO: zaimplementować dwie matody w klasie Measurment Class: toMap(), toJson() --> pierwsza to inputu do bazy, druga do ładowania do widoku

class HiveScreen extends StatefulWidget {
  HiveScreen({Key key}) : super(key: key);

  @override
  _HiveScreenState createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  final Connectivity _connectivity = Connectivity();
  Color _connectionStatus = Colors.red;
  Color _wifiStatus = Colors.red;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<WifiResult> ssidList = [];

  String _time = 'Czas pomiaru';
  String _temperature = '', _humidity = '', _pressure = '', _tempModule = '';
  Color color = Colors.redAccent[400];

  //TODO: implement on ESP32 decimal precision
  double roundDouble(String value, int places) {
    double mod = pow(10.0, places);
    return ((double.parse(value) * mod).round().toDouble() / mod);
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // loadData();n
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  File _image;
  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 18, height: 2);
    var screenHeight = MediaQuery.of(context).size.height;

    List<WifiResult> list;
    Wifi.list('key').then((value) => list = value);
    print(list);

    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Pomiary UL"),
              ),
              drawer: MainDrawer(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Container(
                            width: 120,
                            height: 110,
                            color: Colors.white,
                            child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(
                                      child: _roundedPhoto('assets/hive.jpg',
                                          _connectionStatus, 100.0, context)),
                                  Positioned(
                                      right: 1,
                                      top: 1,
                                      child: StreamBuilder<bool>(
                                          stream: _hiveActive("Super-UL"),
                                          builder: (context,
                                              AsyncSnapshot<bool> snapshot) {
                                            return Column(
                                              children: [
                                                _roundedPhoto(
                                                    'assets/hive.jpg',
                                                    (snapshot.data == true)
                                                        ? Colors.green
                                                        : Colors.red[400],
                                                    10.0,
                                                    context)
                                              ],
                                            );
                                          }))
                                ]),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: Text('$_time ',
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                      Container(
                          margin:
                              EdgeInsets.only(top: 20, bottom: screenHeight * 0.1),
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
                                    FaIcon(FontAwesomeIcons.tint,
                                        color: Colors.blue),
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
                                        style:
                                            TextStyle(color: Colors.indigo[800])),
                                  ],
                                ),
                              ])),
                      // Container(
                      //     margin: EdgeInsets.only(top: 30, right: 30, left: 30),
                      //     child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Column(children: [
                      //             Icon(Icons.timer,
                      //                 color: Colors.yellow[700], size: 30),
                      //             Text('czuwanie',
                      //                 style: TextStyle(fontSize: 14, height: 1)),
                      //           ]),
                      //           Column(
                      //             children: [
                      //               ToggleButtons(
                      //                   children: [
                      //                     Text('0.5',
                      //                         style: TextStyle(
                      //                             fontSize: 14,
                      //                             fontWeight: FontWeight.bold)),
                      //                     Text('1',
                      //                         style: TextStyle(
                      //                             fontSize: 14,
                      //                             fontWeight: FontWeight.bold)),
                      //                     Text('2',
                      //                         style: TextStyle(
                      //                             fontSize: 14,
                      //                             fontWeight: FontWeight.bold))
                      //                   ],
                      //                   color: Colors.greenAccent[700],
                      //                   isSelected: _selections1,
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   borderWidth: 2,
                      //                   borderColor: Colors.greenAccent[700],
                      //                   selectedBorderColor:
                      //                       Colors.greenAccent[700],
                      //                   fillColor: Colors.greenAccent[700],
                      //                   selectedColor: Colors.white,
                      //                   onPressed: (int index) {
                      //                     setState(() {
                      //                       for (int indexBtn = 0;
                      //                           indexBtn < _selections1.length;
                      //                           indexBtn++) {
                      //                         if (indexBtn == index) {
                      //                           _selections1[indexBtn] = true;
                      //                         } else {
                      //                           _selections1[indexBtn] = false;
                      //                         }
                      //                       }
                      //                     });
                      //                   })
                      //             ],
                      //           ),
                      //         ])),
                      // Container(
                      //   margin: EdgeInsets.only(
                      //       top: 10, right: 30, left: 30, bottom: 10),
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Column(children: [
                      //           FaIcon(FontAwesomeIcons.moon,
                      //               color: Colors.yellow[700], size: 27),
                      //           Text('uśpienie',
                      //               style: TextStyle(fontSize: 14, height: 1)),
                      //         ]),
                      //         Column(children: [
                      //           ToggleButtons(
                      //               children: [
                      //                 Text('15',
                      //                     style: TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold)),
                      //                 Text('30',
                      //                     style: TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold)),
                      //                 Text('60',
                      //                     style: TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold)),
                      //                 Text('120',
                      //                     style: TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.bold))
                      //               ],
                      //               color: Colors.green,
                      //               isSelected: _selections2,
                      //               borderRadius: BorderRadius.circular(10),
                      //               borderWidth: 2,
                      //               borderColor: Colors.greenAccent[700],
                      //               selectedBorderColor: Colors.greenAccent[700],
                      //               fillColor: Colors.greenAccent[700],
                      //               selectedColor: Colors.white,
                      //               onPressed: (int index) {
                      //                 setState(() {
                      //                   for (int indexBtn = 0;
                      //                       indexBtn < _selections2.length;
                      //                       indexBtn++) {
                      //                     if (indexBtn == index) {
                      //                       _selections2[indexBtn] = true;
                      //                     } else {
                      //                       _selections2[indexBtn] = false;
                      //                     }
                      //                   }
                      //                 });
                      //               })
                      //         ]),
                      //       ]),
                      // ),
                      Builder(
                        // szybki pomiar
                        builder: (BuildContext context) {
                          final database = Provider.of<AppDatabase>(context);
                          return ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width - 60,
                              height: 40.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(13.0)),
                              child: (RaisedButton(
                                onPressed: () async {
                                  Measure measure = await fetchMeasures();
                                  List<Measure> todaysMeasures = await database
                                      .getMeasuresFromDate(DateTime.now());
                                  print('TODAYS MEASURES:');
                                  print(todaysMeasures);
                                  setState(() {
                                    _temperature = measure.temperature.toString();
                                    _humidity = measure.humidity.toString();
                                    _pressure = measure.pressure.toString();
                                    _time = DateFormat('HH:mm:ss dd MMMM yyyy')
                                        .format(measure.timestamp)
                                        .toString();
                                  });
                                  print(measure.toString());
                                  //Save to database
                                  database.insertMeasure(measure);
                                  final snackBar = SnackBar(
                                      content: Row(children: [
                                        Icon(Icons.check),
                                        SizedBox(width: 20),
                                        Expanded(child: Text("Pomiar zrobiony"))
                                      ]),
                                      action: SnackBarAction(
                                          label: 'Pokaż',
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MeasuresScreen()),
                                            );
                                          }),
                                      duration: const Duration(seconds: 1));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                },
                                child: const Text('Szybki pomiar',
                                    style: TextStyle(fontSize: 14)),
                                color: Colors.green,
                                textColor: Colors.white,
                              )));
                        },
                      ),
                      Builder(builder: (BuildContext context) {
                        final database = Provider.of<AppDatabase>(context);
                        return ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width - 60,
                            height: 40.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(13.0)),
                            child: (RaisedButton(
                              onPressed: () async {
                                List<Measure> allMeasures =
                                    await fetchAllMeasures();
                                var numOfMeasuresAdded = 0;
                                for (Measure item in allMeasures) {
                                  print(database.insertMeasure(item));
                                  numOfMeasuresAdded += 1;
                                  // }
                                }
                                final snackBar = SnackBar(
                                    content: Row(children: [
                                      FaIcon(FontAwesomeIcons.sortAmountDownAlt),
                                      SizedBox(width: 20),
                                      Expanded(
                                          child: Text("Pomiary zaciągnięte +" +
                                              numOfMeasuresAdded.toString()))
                                    ]),
                                    action: SnackBarAction(
                                        label: 'Pokaż',
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChartScreen()),
                                          );
                                        }),
                                    duration: const Duration(seconds: 1));
                                Scaffold.of(context).showSnackBar(snackBar);
                              },
                              child: const Text('Pobierz wszystkie pomiary',
                                  style: TextStyle(fontSize: 14)),
                              color: Colors.yellow[800],
                              textColor: Colors.white,
                            )));
                      }),
                      Builder(
                        // uśpij moduł
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
                                        FaIcon(FontAwesomeIcons.moon,
                                            color: Colors.white),
                                        SizedBox(width: 20),
                                        Expanded(child: Text(reponse))
                                      ]),
                                      duration: const Duration(seconds: 1));
                                  Vibration.vibrate(pattern: [10, 200, 100, 500]);
                                  Scaffold.of(context).showSnackBar(snackBar);
                                },
                                child: Text('Uśpij moduł',
                                    style: TextStyle(fontSize: 14)),
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
                              // usuń pomiary
                              builder: (context) {
                                return ButtonTheme(
                                    minWidth:
                                        (MediaQuery.of(context).size.width - 60) /
                                                2 -
                                            10,
                                    height: 40.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(13.0)),
                                    child: (RaisedButton(
                                      onLongPress: () async {
                                        String reponse = await deleteMeasuresFile();
                                        final snackBar = SnackBar(
                                            content: Row(children: [
                                              FaIcon(FontAwesomeIcons.skull,
                                                  color: Colors.white),
                                              SizedBox(width: 20),
                                              Expanded(child: Text(reponse)),
                                            ]),
                                            duration: const Duration(seconds: 1));
                                        Scaffold.of(context).showSnackBar(snackBar);
                                      },
                                      child: Text('Usuń pomiary',
                                          style: TextStyle(fontSize: 14)),
                                      color: Colors.pinkAccent,
                                      textColor: Colors.white,
                                    )));
                              },
                            ),
                            Builder(
                              // sync time
                              builder: (context) {
                                return ButtonTheme(
                                    minWidth:
                                        (MediaQuery.of(context).size.width - 60) /
                                                2 -
                                            10,
                                    height: 40.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(13.0)),
                                    child: (RaisedButton(
                                      onPressed: () async {
                                        String reponse = await syncTime();
                                        final snackBar = SnackBar(
                                            content: Row(children: [
                                              Icon(Icons.av_timer,
                                                  color: Colors.white),
                                              SizedBox(width: 20),
                                              Expanded(
                                                  child: Text(
                                                      'Zegar zsynchronizowany'))
                                            ]),
                                            duration: const Duration(seconds: 1));
                                        Scaffold.of(context).showSnackBar(snackBar);
                                      },
                                      child: Text('Synchronizuj czas',
                                          style: TextStyle(fontSize: 14)),
                                      color: Colors.green,
                                      textColor: Colors.white,
                                    )));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ));
        });
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
        String wifiName, wifiIP, wifiBSSID, macAddress;
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

        try {
          wifiBSSID = (await _connectivity.getWifiBSSID()).toString();
          print(wifiBSSID);
        } on PlatformException catch (e) {
          print(e.toString());
          wifiName = "Failed to get Wifi BSSID";
        }

        if (wifiIP.startsWith('192.168.4.')) {
          try {
            macAddress = (await getMacAddress()).toString();
            print(macAddress);
          } on PlatformException catch (e) {
            print(e.toString());
            wifiName = "Failed to get Wifi BSSID";
          }
        }

        setState(() {
          if (macAddress == 'B4:E6:2D:F6:C9:8D') {
            _connectionStatus = Colors.greenAccent[400];
          } else {
            _connectionStatus = Colors.grey[400];
          }
        });
        break;

      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = Colors.tealAccent);
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = Colors.grey[400]);
        break;
      default:
        setState(() => _connectionStatus = Colors.grey[400]);
        break;
    }
  }

  GestureDetector _roundedPhoto(
          var assetPath, Color connStatus, var size, context) =>
      GestureDetector(
          onTap: () {
            Wifi.connection("Super-UL", "superpszczelarz");
            print("Tapped");
          },
          onLongPress: () {
            _showPicker(context);
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                color: connStatus,
                image: new DecorationImage(
                  image: _image == null
                      ? AssetImage("assets/hive.jpg")
                      : FileImage(File(
                          "/var/mobile/Containers/Data/Application/9F8CA21F-22F8-4574-959E-324E5DA9BF1C/Documents/image_picker_45868901-98F0-4732-A726-5066B7C4EB48-1476-0000008FF6A9E2B8.jpg")),
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
          ));

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria zdjęć'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Aparat'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 300,
        maxHeight: 300);
    setState(() {
      _image = image;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    print(appDir);
    final String fileName = path.basename(image.path);
    print(fileName);
    final File savedImage = await image.copy('${appDir.path}/$fileName');
    print(savedImage);
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 300,
        maxHeight: 300);
    setState(() {
      _image = image;
    });
  }

  void loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
        for (var i in ssidList) {
          if (i.ssid == "Super-UL") {
            _wifiStatus = Colors.green;
          }
        }
      });
    });
  }

  Stream<bool> _hiveActive(String hiveSsid) async* {
    while (true) {
      List<WifiResult> wifiList = [];
      List<String> ssidList = [];
      wifiList = await Wifi.list('');
      for (var network in wifiList) {
        if (network.ssid != null) {
          ssidList.add(network.ssid);
        }
      }
      if (ssidList.contains(hiveSsid)) {
        yield true;
      } else {
        yield false;
      }
      await Future.delayed(new Duration(milliseconds: 1000));
    }
  }
}
