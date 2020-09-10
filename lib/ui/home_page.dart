import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/moor_database.dart';
import 'package:flutter/material.dart';
import '../widgets/httpMethods.dart';

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
            // Expanded(child: _buildinputMeasure(context)),
          ],
        ));
  }

//   Builder _buildinputMeasure(BuildContext context) {
//     final database = Provider.of<AppDatabase>(context);
//     return Builder(builder: (context) {
//       return ButtonTheme(
//           minWidth: MediaQuery.of(context).size.width - 120,
//           height: 40.0,
//           shape: RoundedRectangleBorder(
//               borderRadius: new BorderRadius.circular(13.0)),
//           child: (RaisedButton(
//             onPressed: () async {
//               Measure measure = await fetchMeasures();
//               print(measure.toString());
//               //Save to database
//               database.insertMeasure(measure);
//               final snackBar = SnackBar(
//                   content: Row(children: [
//                     Icon(Icons.thumb_up),
//                     SizedBox(width: 20),
//                     Expanded(child: Text("Pomiar zrobiony"))
//                   ]),
//                   duration: const Duration(seconds: 1));
//               Scaffold.of(context).showSnackBar(snackBar);
//             },
//             child: const Text('Szybki pomiar', style: TextStyle(fontSize: 14)),
//             color: Colors.green,
//             textColor: Colors.white,
//           )));
//     });
//   }
}
