import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import './Hive.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
              child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: Column(
              children: [
                _roundedPhoto('assets/profilowe.jpg', Colors.orange, 100.0, context)
              ],
            ),
          ))
        ],
      ),
    );
  }

  GestureDetector _roundedPhoto(
          var assetPath, Color connStatus, var size, context) =>
      GestureDetector(
          onLongPress: () {
            _showPicker(context);
          },
          child: Container(
            width: size,
            height: size,
            margin: EdgeInsets.only(left: 15, bottom: 20),
            decoration: BoxDecoration(
                color: connStatus,
                image: new DecorationImage(
                  image: _image == null
                      ? AssetImage(assetPath) //default photo
                      : FileImage(_image), // photo from image picker  
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
    final fileName = path.basename(image.path);
    print(fileName);
    final savedImage = await image.copy('${appDir.path}/$fileName');
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

  
}
