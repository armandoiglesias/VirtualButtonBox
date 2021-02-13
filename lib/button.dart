import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_button_box/model/actionButton.dart';
import 'package:virtual_button_box/providers/db_provider.dart';
import 'package:virtual_button_box/providers/bluetooth_provider.dart';

class ActionButton extends StatefulWidget {
  final String character;
  final String path;
  final int indice;
  ActionButton(
      {this.character,
      // @required this.connection,
      this.path = "assets/images/warning.png",
      this.indice});

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
      // color: this.isPressed ? Colors.green : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FittedBox(
            child: Center(
                child: _image == null
                    ? Container(
                        height: 100.0,
                        width: 100.0,
                        child: Image(
                          image: widget.path.contains("asset")
                              //  Image.asset(   widget.path)
                              ? AssetImage(widget.path)
                              : FileImage(File(widget.path)),
                          // : Image.file(File(widget.path)),
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(
                        height: 100.0,
                        width: 100.0,
                        child: Image.file(
                          _image,
                          fit: BoxFit.fill,
                        ),
                      )),
          ),
          // Text(widget.character)
        ],
      ),
      onPressed: () {
        setState(() {
          this.isPressed = !this.isPressed;
        });
        if (BluetoothProvider.btp.connection == null) {
          debugPrint("Sin conexion Bluetooth");
          return;
        }

        debugPrint("Es una prueba " + widget.character);
        BluetoothProvider.btp.sendMessage(widget.character);
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

        DbProvider.db.getButton(widget.indice).then((valor) {
          if (valor == null) {
            DbProvider.db.insert(ActionButtonModel(
                filePath: pickedFile.path,
                indice: widget.indice,
                isToggle: 1,
                texto: widget.character));
          } else {
            valor.filePath = pickedFile.path;
            DbProvider.db.update(valor);
          }
        });
      } else {
        print('No image selected.');
      }
    });
  }
}
