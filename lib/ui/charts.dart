import 'package:flutter/material.dart';
import '../data/moor_database.dart';
import 'main_drawer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<Measure> _series1;
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase(DateTime.now()).then((value) => this._series1 = value);
    print(this._series1);
    this._series1 = [];
  }

  Future<List<Measure>> _getDataFromDatabase(DateTime day) async {
    var database = Provider.of<AppDatabase>(context);
    final List<Measure> list = await (database.getMeasuresFromDate(day));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    var dateForGraphs = DateTime.now();
    _getDataFromDatabase(DateTime.now()).then((value) => _series1 = value);
    // print(_series1);
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
                        _dateTime.toString());
                    showRoundedDatePicker(
                      context: context,
                      initialDate:
                          _dateTime == null ? measuresDays.last : _dateTime,
                      firstDate: DateTime(DateTime.now().year - 1),
                      lastDate: DateTime(DateTime.now().year + 1),
                      borderRadius: 16,
                      theme: ThemeData(primarySwatch: Colors.orange),
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
                    ).then((pickedClendarDate) {
                      setState(() {
                        _dateTime = pickedClendarDate;
                        print("Wybrany initial date: " + _dateTime.toString());
                        dateForGraphs = pickedClendarDate;
                        _getDataFromDatabase(dateForGraphs)
                            .then((value) => _series1 = value);
                        // print(_series1);
                      });
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
                      height: 300,
                      margin: EdgeInsets.only(left: 5, right: 1),
                      child: charts.TimeSeriesChart(
                        /*seriesList=*/ [
                          charts.Series<Measure, DateTime>(
                            id: 'Temperatura w ulu',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.blue.shadeDefault,
                            domainFn: (Measure measure, _) => measure.timestamp,
                            measureFn: (Measure measure, _) =>
                                measure.temperature,
                            data: this._series1,
                          ),
                        ],
                        defaultInteractions: false,
                        defaultRenderer: charts.LineRendererConfig(
                          includePoints: true,
                          includeArea: true,
                          stacked: true,
                        ),
                        animate: false,
                        primaryMeasureAxis: new charts.NumericAxisSpec(
                            viewport: new charts.NumericExtents(20,27)),
                        behaviors: [
                          // Add title.
                          charts.ChartTitle('Temperatura w ulu'),
                          // Add legend.
                          charts.SeriesLegend(
                              position: charts.BehaviorPosition.bottom),
                          //Add pan and scroll behaviour
                          new charts.PanAndZoomBehavior(),
                          // Highlight X and Y value of selected point.
                          charts.LinePointHighlighter(
                            showHorizontalFollowLine:
                                charts.LinePointHighlighterFollowLineType.all,
                            showVerticalFollowLine: charts
                                .LinePointHighlighterFollowLineType.nearest,
                          ),
                        ],
                      ))
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                      height: 300,
                      margin: EdgeInsets.only(left: 5, right: 1),
                      child: charts.TimeSeriesChart(
                        /*seriesList=*/ [
                          charts.Series<Measure, DateTime>(
                            id: 'Wilgotność w ulu',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.blue.shadeDefault,
                            domainFn: (Measure measure, _) => measure.timestamp,
                            measureFn: (Measure measure, _) => measure.humidity,
                            data: this._series1,
                          ),
                        ],
                        defaultInteractions: false,
                        defaultRenderer: charts.LineRendererConfig(
                          includePoints: true,
                          includeArea: true,
                          stacked: true,
                        ),
                        animate: false,
                        primaryMeasureAxis: new charts.NumericAxisSpec(
                            viewport: new charts.NumericExtents(0, 100)),
                        behaviors: [
                          // Add title.
                          charts.ChartTitle('Wilgotność w ulu'),
                          // Add legend.
                          charts.SeriesLegend(
                              position: charts.BehaviorPosition.bottom),
                          //Add pan and scroll behaviour
                          new charts.PanAndZoomBehavior(),
                          // Highlight X and Y value of selected point.
                          charts.LinePointHighlighter(
                            showHorizontalFollowLine:
                                charts.LinePointHighlighterFollowLineType.all,
                            showVerticalFollowLine: charts
                                .LinePointHighlighterFollowLineType.nearest,
                          ),
                        ],
                      ))
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                      height: 300,
                      margin: EdgeInsets.only(left: 5, right: 1),
                      child: charts.TimeSeriesChart(
                        /*seriesList=*/ [
                          charts.Series<Measure, DateTime>(
                            id: 'Ciśnienie w ulu',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.blue.shadeDefault,
                            domainFn: (Measure measure, _) => measure.timestamp,
                            measureFn: (Measure measure, _) => measure.pressure,
                            data: this._series1,
                          ),
                        ],
                        defaultInteractions: false,
                        defaultRenderer: charts.LineRendererConfig(
                          includePoints: true,
                          includeArea: true,
                          stacked: true,
                        ),
                        animate: false,
                        primaryMeasureAxis: new charts.NumericAxisSpec(
                            viewport: new charts.NumericExtents(950, 1050)),
                        behaviors: [
                          // Add title.
                          charts.ChartTitle('Ciśnienie w ulu'),
                          // Add legend.
                          charts.SeriesLegend(
                              position: charts.BehaviorPosition.bottom),
                          //Add pan and scroll behaviour
                          new charts.PanAndZoomBehavior(),
                          // Highlight X and Y value of selected point.
                          charts.LinePointHighlighter(
                            showHorizontalFollowLine:
                                charts.LinePointHighlighterFollowLineType.all,
                            showVerticalFollowLine: charts
                                .LinePointHighlighterFollowLineType.nearest,
                          ),
                        ],
                      ))
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
}
