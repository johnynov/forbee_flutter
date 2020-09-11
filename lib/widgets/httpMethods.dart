import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import '../data/moor_database.dart';
import 'package:http/http.dart' as http;

String hive_url = "http://192.168.4.1";

Future<Measure> fetchMeasures() async {
  print("Making instant measure...");
  var getMeasuresUrl = hive_url + "/measures/now";
  final response = await http.get(getMeasuresUrl);
  if (response.statusCode == 200) {
    List<String> values = response.body.split(';');
    try {
      var measure = Measure(
          id: null,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              (int.parse(values[0]) - 3600 * 2) * 1000),
          temperature: double.parse(values[1]),
          humidity: double.parse(values[2]),
          pressure: double.parse(values[3]),
          boxTemperature: double.parse(values[4]),
          sentToFirebase: null);
      return measure;
    } catch (e) {
      print(e.toString());
    }
  } else {
    throw Exception('Failed to make get request');
  }
}

Future<List<Measure>> fetchAllMeasures() async {
  print("Getting all measures..");
  var getMeasuresUrl = hive_url + "/measures/all";
  final response = await http.get(getMeasuresUrl);
  if (response.statusCode == 200) {
    List<Measure> measuresList = [];
    List measuresFromBody = response.body.split('\r\n');
    measuresFromBody.removeLast();
    print(measuresFromBody);
    for (var item in measuresFromBody) {
      List<String> values = item.split(';');
      var measure = Measure(
          id: null,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              (int.parse(values[0]) - 3600 * 2) * 1000),
          temperature: double.parse(values[1]),
          humidity: double.parse(values[2]),
          pressure: double.parse(values[3]),
          boxTemperature: double.parse(values[4]),
          sentToFirebase: null);
      print(measure);
      measuresList.add(measure);
    }
    return measuresList;
  }
}

Future<String> setToSleep() async {
  print("Making GET http request..");
  var getMeasuresUrl = hive_url + "/sleep";
  final response = await http.get(getMeasuresUrl);
  if (response.statusCode == 200) {
    print('Setting to sleep');
    return 'Moduł uśpiony, zzz...';
  } else {
    throw Exception('Failed to make get request');
    return null;
  }
}

Future<String> getMacAddress() async {
  print("Making GET mac address..");
  var getMacaddress = hive_url + "/mac";
  final response = await http.get(getMacaddress);
  if (response.statusCode == 200) {
    var mac = Utf8Codec().decode(response.bodyBytes).toString();
    return mac;
  } else {
    throw Exception('Failed to make get request');
    return null;
  }
}

Future<String> deleteMeasuresFile() async {
  print("Making GET http request..");

  var getMeasuresUrl = hive_url + "/measures/delete";
  final response = await http.get(getMeasuresUrl);
  if (response.statusCode == 200) {
    return 'Pomiary pogrzebane żywcem.';
  } else {
    throw Exception('Failed to make get request');
    return null;
  }
}

String mapParameters(Map<dynamic, dynamic> map) {
  String paramstring;
  map.forEach(
      (k, v) => paramstring += ('?' + k.toString() + '=' + v.toString()));
  return paramstring;
}

Future<String> syncTime() async {
  print("Making POST http request..");
  var url = hive_url + "/clock/set";
  var ms = (new DateTime.now()).millisecondsSinceEpoch;
  String time = (ms / 1000 + 3600 * 2).round().toString();
  String u = url + "?time=" + time;

  http.Response response = await http.post(u);
  if (response.statusCode == 200) {
    return "Ul jest na czasie.";
  } else {
    throw Exception('Failed to make get request');
    return "null";
  }
}
