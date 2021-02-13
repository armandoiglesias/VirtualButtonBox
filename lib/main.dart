import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vibration/vibration.dart';
import 'package:virtual_button_box/button.dart';
import 'package:wakelock/wakelock.dart';

import 'package:virtual_button_box/providers/db_provider.dart';
import 'package:virtual_button_box/providers/bluetooth_provider.dart';

import 'button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Button Box',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Virtual Button Box'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  // final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// class ButtonBox extends StatelessWidget {
//   final Icon icon;
//   final String character;
//   // final FlutterBluetoothSerial bluetooth;
//   final BluetoothConnection connection;

//   ButtonBox({this.icon, this.character, this.connection});

//   @override
//   Widget build(BuildContext context) {
//     return FlatButton(
//       autofocus: false,
//       onPressed: () async {
//         //if (await Vibration.hasVibrator()) {
//         //Vibration.vibrate();
//         Vibration.vibrate(duration: 300, amplitude: 128);
//         debugPrint('Tecla : $character');
//         connection.output.add(utf8.encode("L"));
//         await connection.output.allSent;

//         if (connection.isConnected) {}
//       },
//       child: IconButton(
//         icon: icon,
//         tooltip: character,
//         onPressed: () {},
//       ),
//     );
//   }
// }

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> listado = new List<Widget>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the bluetooth
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  // Define some variables, which will be required later
  // List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  // BluetoothConnection _connection;
  _MyHomePageState();

  Widget getButton(String _char, String iconName) {
    return RawMaterialButton(
      onPressed: () {
        if (BluetoothProvider.btp.isConnected) {
          Vibration.vibrate(duration: 100, amplitude: 128);
          // debugPrint('Tecla : $_char');
          BluetoothProvider.btp.sendMessage(_char);
        }
      },
      elevation: 3.0,
      fillColor: Colors.white,
      child: Image(
          image: AssetImage(iconName == null
              ? "assets/images/warning.png"
              : "assets/images/$iconName")),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }

  final List<String> letras = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m"
  ];
  void getButtonBox() {
    for (var i = 0; i < 13; i++) {
      DbProvider.db.getButton(i).then((value) {
        if (value == null) {
          listado.add(ActionButton(
            character: letras[i],
            indice: i,
          ));
        } else {
          listado.add(ActionButton(
            character: letras[i],
            path: value.filePath,
            indice: value.indice,
          ));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    BluetoothProvider.btp.bluetoothConnectionState();

    // bluetoothConnectionState();
    getButtonBox();

    Wakelock.enable();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
    Wakelock.disable();

    DbProvider.db.close();
    BluetoothProvider.btp.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          centerTitle: true,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.bluetooth), onPressed: _showDialog)
          ],
        ),
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.10),
      ),
      body: SafeArea(
        child: GridView.count(
          primary: true,
          crossAxisSpacing: 1,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2),
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 1,
                  crossAxisCount: 2,
                  children:
                      // <Widget>[
                      this
                          .listado
                          .take(4)
                          .map((listado) => Container(
                                padding: const EdgeInsets.all(5),
                                child: listado,
                                //color: Colors.teal[100],
                              ))
                          .toList()),
              //color: Colors .teal[100],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                  primary: true,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: this
                      .listado
                      .skip(4)
                      .take(9)
                      .map((listado) => Container(
                            padding: const EdgeInsets.all(4),
                            child: listado,
                            // color: Colors.teal[100],
                          ))
                      .toList()),
              // color: Colors.teal[200],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];

    if (BluetoothProvider.btp.connectedDevices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      BluetoothProvider.btp.connectedDevices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }

  _showDialog() {
    showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0)), //this right here
                  child: Container(
                    height: 200,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _buildView()),
                  ));
            }) ??
        Navigator.of(context).pop();
  }

  _buildView() {
    return Container(
      height: 200,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Device:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton(
                // To be implemented : _getDeviceItems()
                items: _getDeviceItems(),
                onChanged: (value) => setState(() => _device = value),
                value: _device,
              ),
              RaisedButton(
                onPressed: () => BluetoothProvider.btp.isConnected
                    ? BluetoothProvider.btp.disconnect()
                    : BluetoothProvider.btp.connect(this._device),
                child: Text(BluetoothProvider.btp.isConnected
                    ? 'Disconnect'
                    : 'Connect'),
              ),
            ],
          )),
    );
  }
}

// https://medium.com/flutter-community/flutter-adding-bluetooth-functionality-1b9715ccc698
