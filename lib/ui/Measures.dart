import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'main_drawer.dart';

import '../data/moor_database.dart';


class MeasuresScreen extends StatefulWidget {
  @override
  _MeasuresScreenState createState() => _MeasuresScreenState();
}

class _MeasuresScreenState extends State<MeasuresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Moje pomiary'),
        ),
        drawer: MainDrawer(),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildMeasuresList(context)),
          ],
        ));
  }

  StreamBuilder<List<Measure>> _buildMeasuresList(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    return StreamBuilder(
      stream: database.watchAllMeasures(),
      builder: (context, AsyncSnapshot<List<Measure>> snapshot) {
        final measures = snapshot.data ?? List();
        return ListView.builder(
          itemCount: measures.length,
          itemBuilder: (_, index) {
            final measure = measures[index];
            return _buildListMeasures(measure, database);
          },
        );
      },
    );
  }

  Widget _buildListMeasures(Measure measure, AppDatabase database) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteMeasure(measure),
        )
      ],
      child: ListTile(
        title: Text(measure.timestamp.toString()),
        subtitle: Text("Te: " +
            measure.temperature.toString() +
            " *C   Wg: " +
            measure.humidity.toString() +
            " %   Ci: " +
            measure.pressure.toString() +
            " hPa"),
      ),
    );
  }
}

// String formatTileTimestamp(DateTime timestemp) {
//   var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", 'en');


//   return dateformatted;
// }
