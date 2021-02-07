import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:image_picker/image_picker.dart';

class ActionButton extends StatefulWidget {
  final String character;
  final BluetoothConnection connection;
  ActionButton({this.character, this.connection});

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  File _image;
  final picker = ImagePicker();
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.grey)),
      color: this.isPressed ? Colors.green : Colors.white,
      child: Center(
          child: _image == null
              ? Image(
                  image: AssetImage("assets/images/warning.png"),
                )
              : Image.file(_image)),
      onPressed: () {
        setState(() {
          this.isPressed = !this.isPressed;
        });
        if (widget.connection == null) {
          debugPrint("Sin conexion Bluetooth");
          return;
        }
        debugPrint("Es una prueba " + widget.character);
      },
      onLongPress: getImage,
      autofocus: false,
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
