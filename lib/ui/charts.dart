import 'dart:core';
import 'package:flutter/material.dart';
import '../data/moor_database.dart';
import 'main_drawer.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/chartParameterTile.dart';

// import 'package:syncfusion_flutter_sliders/sliders.dart';

// import 'package:charcode/charcode.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<Measure> _series1;
  DateTime selectedDate;

  bool rebuild = false;

  @override
  void initState() {
    super.initState();

    // _rangeController = RangeController(start: _values.start, end: _values.end);
  }

  @override
  void dispose() {
    // _rangeController.dispose();
    super.dispose();
  }

  Future<List<Measure>> _getDataFromDatabase(DateTime day) async {
    var database = Provider.of<AppDatabase>(context);
    final List<Measure> list = await (database.getMeasuresFromDate(day));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    _getDataFromDatabase(DateTime.now()).then((value) => _series1 = value);
    print(_series1);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              bottom: TabBar(tabs: [
                Tab(text: "Temperatura"),
                Tab(text: "Wilgotność"),
                Tab(text: "Ciśnienie"),
              ]),
              actions: <Widget>[
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.calendarAlt),
                  tooltip: 'Wybierz dzień',
                  iconSize: 20,
                  onPressed: () async {
                    // setState(() => rebuild = false);
                    List<DateTime> measuresDays =
                        await database.getDistinctDays();
                    List<DateTime> daysToHide = calculateDayList(
                        DateTime.utc((DateTime.now().year - 1), 1, 1),
                        DateTime.utc((DateTime.now().year + 1), 12, 31));
                    List<DateTime> daysToShow = [];
                    daysToHide.forEach((element) {
                      if (!measuresDays.contains(element)) {
                        daysToShow.add(element);
                      }
                    });
                    print("Zapamiętana wartość datetime: " +
                        selectedDate.toString());
                    showRoundedDatePicker(
                            context: context,
                            height: 300,
                            initialDate: selectedDate == null
                                ? measuresDays.last
                                : selectedDate,
                            firstDate: DateTime(DateTime.now().year - 1),
                            lastDate: DateTime(DateTime.now().year + 1),
                            borderRadius: 16,
                            theme: ThemeData(
                                primarySwatch: Colors.amber,
                                accentColor: Colors.green[500],
                                textTheme: TextTheme(
                                  body1: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                                disabledColor: Colors.grey),
                            listDateDisabled: daysToShow,
                            customWeekDays: [
                              "Pon",
                              "Wt",
                              "Śr",
                              "Czw",
                              "Pt",
                              "Sob",
                              "Nd"
                            ],
                            textPositiveButton: "WYBIERZ",
                            textNegativeButton: "ANULUJ")
                        .then((pickedClendarDate) {
                      if (pickedClendarDate != null) {
                        setState(() {
                          rebuild = true;
                          selectedDate = pickedClendarDate;
                          print("Wybrany data z kalendarza: " +
                              selectedDate.toString());
                          _getDataFromDatabase(pickedClendarDate)
                              .then((value) => _series1 = value);
                          // print(_series1);
                        });
                      }
                    });
                  },
                )
              ],
              title: Text('Wykresy pomiarów'),
            ),
            drawer: MainDrawer(),
            body: TabBarView(children: [
              Column(
                children: <Widget>[
                  Container(
                    height: screenHeight * 0.5,
                    child: SfCartesianChart(
                        // title: ChartTitle(text: DateFormat('dd MMMM yyyy').format(selectedDate).toString()),
                        enableAxisAnimation: true,
                        primaryXAxis: DateTimeAxis(
                            title: AxisTitle(text: "Godzina"),
                            intervalType: DateTimeIntervalType.hours,
                            majorTickLines: MajorTickLines(
                                size: 7, width: 2, color: Colors.red),
                            minorTickLines: MinorTickLines(
                                size: 5, width: 2, color: Colors.blue),
                            minorTicksPerInterval: 1),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: "Temperatura"),
                            labelFormat: "{value} \u00B0C"),
                        series: <LineSeries>[
                          LineSeries<Measure, DateTime>(
                              dataSource: this._series1,
                              color: Colors.blueAccent,
                              xValueMapper: (Measure measure, _) =>
                                  measure.timestamp,
                              yValueMapper: (Measure measure, _) =>
                                  measure.temperature,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: false),
                              markerSettings: MarkerSettings(isVisible: true)),
                        ],
                        // onMarkerRender: _renderGradient(),
                        tooltipBehavior: TooltipBehavior(enable: true)),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            parameterTile(
                                context,
                                minTempTile),
                            parameterTile(
                                context, maxTempTile
                                )
                          ],
                        ),
                        Row()
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: screenHeight * 0.5,
                    child: SfCartesianChart(
                        // title: ChartTitle(text: DateFormat('dd MMMM yyyy').format(selectedDate).toString()),
                        enableAxisAnimation: true,
                        primaryXAxis: DateTimeAxis(
                            title: AxisTitle(text: "Godzina"),
                            intervalType: DateTimeIntervalType.hours,
                            majorTickLines: MajorTickLines(
                                size: 7, width: 2, color: Colors.red),
                            minorTickLines: MinorTickLines(
                                size: 5, width: 2, color: Colors.blue),
                            minorTicksPerInterval: 1),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: "Wilgotność"),
                            labelFormat: "{value} \u00B0C"),
                        series: <LineSeries>[
                          LineSeries<Measure, DateTime>(
                              dataSource: this._series1,
                              color: Colors.blueAccent,
                              xValueMapper: (Measure measure, _) =>
                                  measure.timestamp,
                              yValueMapper: (Measure measure, _) =>
                                  measure.humidity,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: false),
                              markerSettings: MarkerSettings(isVisible: true)),
                        ],
                        // onMarkerRender: _renderGradient(),
                        tooltipBehavior: TooltipBehavior(enable: true)),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            parameterTile(
                                context,
                                minHumidityTile),
                            parameterTile(
                                context, maxHumidityTile
                                )
                          ],
                        ),
                        Row()
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: screenHeight * 0.5,
                    child: SfCartesianChart(
                        enableAxisAnimation: false,
                        primaryXAxis: DateTimeAxis(
                            title: AxisTitle(text: "Godzina"),
                            intervalType: DateTimeIntervalType.hours),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: "Ciśnienie"),
                            labelFormat: "{value} hPa"),
                        series: <LineSeries>[
                          LineSeries<Measure, DateTime>(
                              dataSource: this._series1,
                              color: Colors.blueAccent,
                              xValueMapper: (Measure measure, _) =>
                                  measure.timestamp,
                              yValueMapper: (Measure measure, _) =>
                                  measure.pressure,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: false),
                              markerSettings: MarkerSettings(isVisible: true)),
                        ],
                        tooltipBehavior: TooltipBehavior(enable: true)),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            parameterTile(
                                context,
                                minPresTile),
                            parameterTile(
                                context, maxPresTile
                                )
                          ],
                        ),
                        Row()
                      ],
                    ),
                  )
                ],
              ),
            ])));
  }

  List<DateTime> calculateDayList(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  String _findMaxParameter() {
    List<double> daysMeasuresList = [];
    print("DANE" + _series1.toString());
    if (_series1 != null) {
      for (var measure in _series1) {
        daysMeasuresList.add(measure.temperature);
        print(measure.temperature);
      }
      if (daysMeasuresList.isNotEmpty) {
        daysMeasuresList.sort();
        print(daysMeasuresList);
        return daysMeasuresList.last.toString();
      }
    } else {
      return "";
    }
  }

  String _findMinParameter() {
    List<double> daysMeasuresList = [];
    print("DANE" + _series1.toString());
    if (_series1 != null) {
      for (var measure in _series1) {
        daysMeasuresList.add(measure.temperature);
        print(measure.temperature);
      }
      if (daysMeasuresList.isNotEmpty) {
        daysMeasuresList.sort();
        print(daysMeasuresList);
        return daysMeasuresList.first.toString();
      }
    } else {
      return "";
    }
  }

  bool is_between(int i, double min, double max) {
    if (min > i && i <= max) {
      return true;
    } else {
      return false;
    }
    ;
  }

  _renderGradient() {
    double nautical_twilight_begin = 4.02;
    double civil_twilight_begin = 4.39;
    double sunrise = 5.12;
    double solar_noon = 10.24;
    double sunset = 15.35;
    double civil_twilight_ends = 16.08; //zmierzch cywilny
    double nautical_twilight_ends = 16.45; // zmierzch morski

    return ((MarkerRenderArgs args) {
      if (args.pointIndex == 0) {
        args.color = const Color.fromRGBO(207, 124, 168, 1);
      } else if (is_between(
          args.pointIndex, nautical_twilight_ends, civil_twilight_begin)) {
        args.color = const Color.fromRGBO(210, 133, 167, 1);
      } else if (is_between(args.pointIndex, civil_twilight_begin, sunrise)) {
        args.color = const Color.fromRGBO(219, 128, 161, 1);
      } else if (is_between(args.pointIndex, sunrise, solar_noon)) {
        args.color = const Color.fromRGBO(213, 143, 151, 1);
      } else if (is_between(args.pointIndex, solar_noon, sunset)) {
        args.color = const Color.fromRGBO(226, 157, 126, 1);
      } else if (is_between(args.pointIndex, sunset, civil_twilight_ends)) {
        args.color = const Color.fromRGBO(220, 169, 122, 1);
      } else if (is_between(
          args.pointIndex, civil_twilight_ends, nautical_twilight_ends)) {
        args.color = const Color.fromRGBO(221, 176, 108, 1);
      } else if (is_between(
          args.pointIndex, nautical_twilight_ends, nautical_twilight_begin)) {
        args.color = const Color.fromRGBO(222, 187, 97, 1);
      }
    });
  }
}
