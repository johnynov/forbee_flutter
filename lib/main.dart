import 'package:flutter/material.dart';
import 'package:forbee/data/moor_database.dart';
import 'package:forbee/ui/charts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'ui/Hive.dart';
import 'ui/main_drawer.dart';
import 'ui/measures.dart';
import 'ui/userAccount.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => AppDatabase(),
      child: MaterialApp(
        title: 'Forbee',
        debugShowCheckedModeBanner: false,
        home: HiveScreen(),
        theme: ThemeData(
          primaryColor: Colors.orange[400]
        ),
        routes: {
          '/hive': (_) => HiveScreen(),
          '/myMeasures': (_) => MeasuresScreen(),
          '/databaseTest' : (_) => ChartScreen(),
          '/userAccount' : (_) => UserAccount(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
         ],
        locale: Locale('pl', 'PL'),
        supportedLocales: [
              const Locale('en', 'US'), // English
              const Locale('pl', 'PL'), // Thai
        ],
      ),
      // create: (BuildContext context) {},
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Marker> allMarkers = [];

  GoogleMapController _controller;
  var location = LatLng(50.063381, 19.978709); //home location

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      onTap: () {
        print('Marker Tapped');
      },
      position: location,
      infoWindow: InfoWindow(
        title: "Moj dom",
        snippet: "home location",
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: location, zoom: 15.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
          ),
        ),
      ]),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: location, zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: location, zoom: 12.0),
    ));
  }
}
