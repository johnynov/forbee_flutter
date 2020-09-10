
import 'package:flutter/material.dart';
import 'package:forbee/main.dart';
import 'package:forbee/ui/Measures.dart';
import 'package:forbee/ui/home_page.dart';
import '../main.dart';
import 'Hive.dart';

class MainDrawer extends StatelessWidget {
  double size = 85;
  var borderColor = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    var scr_h = MediaQuery.of(context).size.height;
    var scr_w = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
          child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Row(children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 90,
                    height: 90,
                    margin: EdgeInsets.only(left: 30, top: 20, bottom: 15),
                    decoration: BoxDecoration(
                        color: borderColor,
                        image: const DecorationImage(
                          image: AssetImage('assets/profilowe.jpg'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: borderColor,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: borderColor,
                            blurRadius: 4,
                            spreadRadius: 2,
                          )
                        ]),
                  ),
                  Container(
                      child: Text('Rysio, Pszczelarz',
                          style: TextStyle(height: 1, fontSize: 16)),
                      margin: EdgeInsets.only(left: 30, bottom: 30))
                ],
              ),
              // Column(
              //   children: <Widget>[
              //     Container(
              //       width: 35,
              //       height: 35,
              //       margin: EdgeInsets.only(left: 25, top: 30, bottom: 15),
              //       decoration: BoxDecoration(
              //         image: const DecorationImage(
              //           image: AssetImage('assets/beekeeper2.png'),
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //     Container(
              //       width: 30,
              //       height: 30,
              //       margin: EdgeInsets.only(left: 25, top: 10, bottom: 10),
              //       decoration: BoxDecoration(
              //         image: const DecorationImage(
              //           image: AssetImage('assets/beekeeper2.png'),
              //           fit: BoxFit.cover,
              //         ),
              //       ),
              //     )
              //   ],
              // ),
            ]),
            ListTile(
              leading: Image.asset('assets/line-chart.png',
                  scale: 1.0, height: 30.0, width: 30.0),
              title: Text('Moje Pomiary'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MeasuresScreen()),
                );
              },
            ),
            ListTile(
              leading: Image.asset('assets/beehive.png',
                  scale: 1.0, height: 40.0, width: 40.0),
              title: Text('Moje Ule'),
              trailing: IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 25,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  }),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HiveScreen()),
                );
              },
            ),
            ListTile(
              leading: Image.asset('assets/line-chart.png',
                  scale: 1.0, height: 30.0, width: 30.0),
              title: Text('Test bazy danych'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
