import 'package:flutter/material.dart';
import '../ui/charts.dart';

class TileParameter {
  String shownValue;
  String unit;
  Color iconColor;
  String caption;
  Icon icon;

  TileParameter(
      this.shownValue, this.unit, this.iconColor, this.caption, this.icon);
}

Widget minParameterTile(BuildContext context, TileParameter tileParameter) {}

Widget maxParameterTile(BuildContext context, TileParameter tileParameter) {}

bool rebuild = true;

TileParameter maxTempTile = TileParameter(
    "", "\u00B0C", Colors.greenAccent, "Maksymalna", Icon(Icons.arrow_upward));
TileParameter minTempTile = TileParameter(
    "", "\u00B0C", Colors.redAccent, "Minimalna", Icon(Icons.arrow_downward));

TileParameter maxHumidityTile = TileParameter(
    "", "%", Colors.greenAccent, "Maksymalna", Icon(Icons.arrow_upward));
TileParameter minHumidityTile = TileParameter(
    "", "%", Colors.redAccent, "Minimalna", Icon(Icons.arrow_downward));

    TileParameter maxPresTile = TileParameter(
    "", "hPa", Colors.greenAccent, "Maksymalna", Icon(Icons.arrow_upward));
TileParameter minPresTile = TileParameter(
    "", "hPa", Colors.redAccent, "Minimaln", Icon(Icons.arrow_downward));

Widget parameterTile(BuildContext context, TileParameter tileParameter) {
  return Container(
      width: 0.45 * MediaQuery.of(context).size.width,
      height: 0.06 * MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Stack(children: [
        Positioned(
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: tileParameter.shownValue,
                  style:
                      TextStyle(color: tileParameter.iconColor, fontSize: 26)),
              TextSpan(
                  text: tileParameter.unit,
                  style: TextStyle(color: Colors.black, fontSize: 23))
            ])),
            right: 20,
            top: MediaQuery.of(context).size.height * 0.012),
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          decoration: new BoxDecoration(
              color: tileParameter.iconColor,
              borderRadius: new BorderRadius.all(const Radius.circular(10.0))),
          margin: EdgeInsets.only(
              left: 0.005 * MediaQuery.of(context).size.height,
              top: MediaQuery.of(context).size.height * 0.006),
          width: rebuild
              ? 0.045 * MediaQuery.of(context).size.height
              : 0.42 * MediaQuery.of(context).size.width,
          height: 0.045 * MediaQuery.of(context).size.height,
          // color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tileParameter.icon,
              Text(rebuild ? "" : tileParameter.caption)
            ],
          ),
        )
      ]));
}
