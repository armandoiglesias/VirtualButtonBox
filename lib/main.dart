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

  final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ButtonBox extends StatelessWidget {
  final Icon icon;
  final String character;
  // final FlutterBluetoothSerial bluetooth;
  final BluetoothConnection connection;

  ButtonBox({this.icon, this.character, this.connection});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      autofocus: false,
      onPressed: () async {
        //if (await Vibration.hasVibrator()) {
        //Vibration.vibrate();
        Vibration.vibrate(duration: 300, amplitude: 128);
        debugPrint('Tecla : $character');
        connection.output.add(utf8.encode("L"));
        await connection.output.allSent;

        if (connection.isConnected) {}
      },
      child: IconButton(
        icon: icon,
        tooltip: character,
        onPressed: () {},
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  final List<Widget> listado = new List<Widget>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the bluetooth
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  BluetoothConnection _connection;
  _MyHomePageState();

  Widget getButton(String _char, String iconName) {
    return RawMaterialButton(
      onPressed: () {
        // if ( _connection == null ){
        //   show("Debe seleccionar un dispositivo Bluetooth");
        //   return ;
        // }

        if (_connection.isConnected) {
          Vibration.vibrate(duration: 100, amplitude: 128);
          // debugPrint('Tecla : $_char');
          _sendMessage(_char);
        }
      },
      elevation: 3.0,
      fillColor: Colors.white,
      child: Image(
          image: AssetImage(iconName == null
              ? "assets/images/warning.png"
              : "assets/images/$iconName")),
      // Icon(
      //   Icons.pause,
      //   //size: 35.0,
      // ),
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );

    // return IconButton(
    //     icon: Icon(Icons.volume_down),
    //     tooltip: _char.toUpperCase(),
    //     onPressed: () {

    //       if (_connection.isConnected) {
    //         Vibration.vibrate(duration: 100, amplitude: 128);
    //         debugPrint('Tecla : $_char');
    //         _sendMessage(_char);
    //       }else{
    //         show("Debe seleccionar un dispositivo Bluetooth");
    //       }
    //     });
  }

  void getButtonBox() {
    listado.add(ActionButton(connection: _connection, character: "a"));
    listado.add(ActionButton(character: "b", connection: _connection));
    listado.add(ActionButton(character: "c", connection: _connection));
    listado.add(ActionButton(character: "d", connection: _connection));
    listado.add(getButton("e", null));
    listado.add(getButton("f", null));
    listado.add(getButton("g", null));
    listado.add(getButton("h", null));
    listado.add(getButton("i", null));
    listado.add(getButton("j", null));
    listado.add(getButton("k", null));
    listado.add(getButton("l", null));
    listado.add(getButton("m", null));
    listado.add(getButton("n", null));
    listado.add(getButton("o", null));
    listado.add(getButton("p", null));
    listado.add(getButton("q", null));
    listado.add(getButton("r", null));
    listado.add(getButton("s", null));
  }

  void _sendMessage(String _char) async {
    String _cadena = _char.toUpperCase();
    String _message = "* 00$_cadena#";
    debugPrint(_message);
    _connection.output.add(utf8.encode(_message));
    await _connection.output.allSent;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    bluetoothConnectionState();
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
    _disconnect();
    Wakelock.disable();
  }

  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // For knowing when bluetooth is connected and when disconnected
    bluetooth.onStateChanged().listen((state) {
      if (state.isEnabled) {
        if (_connection.isConnected) {
          setState(() {
            _connected = true;
          });
        } else {
          setState(() {
            _connected = false;
          });
        }
      }
    });

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  // _gotoBluetooth() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute<void>(builder: (BuildContext context) {
  //       return Scaffold(
  //           appBar: AppBar(
  //             title: Text('Linked Bluetooth'),
  //           ),
  //           body: Container(
  //             height: 200,
  //             child: Padding(
  //                 padding: const EdgeInsets.all(12.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Text(
  //                       'Device:',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     DropdownButton(
  //                       // To be implemented : _getDeviceItems()
  //                       items: _getDeviceItems(),
  //                       onChanged: (value) => setState(() => _device = value),
  //                       value: _device,
  //                     ),
  //                     RaisedButton(
  //                       onPressed: _connect,
  //                       child: Text(_connected ? 'Disconnect' : 'Connect'),
  //                     ),
  //                   ],
  //                 )),
  //           ));
  //     }),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    DbProvider.db.database;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.bluetooth),
              onPressed: /*_gotoBluetooth*/ _showDialog)
        ],
      ),
      body:
          /*_connection == null
          ? Text("Debe Conectar al Bluetooth")
          :*/
          GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(3),
            child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(2),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
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
            padding: const EdgeInsets.all(8),
            child: GridView.count(
                primary: false,
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _connect() {
    if (_device == null) {
      show('No device selected');
    } else {
      bluetooth.isEnabled.then((isConnected) {
        // if (isConnected) {
        BluetoothConnection.toAddress(_device.address)
            .then((BluetoothConnection response) {
          // for (var i = 0; i < 100; i++) {
          //   Timer(Duration(milliseconds: 200), () {
          //     response.output
          //         .add(utf8.encode("*" + String.fromCharCode(12) + "00L#"));
          //   });
          // }
          _connection = response;

          // setState(() {
          //   _connection = response;
          // });
        });
      });
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() {
    _connection.finish();
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
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
                onPressed: _connect,
                child: Text(_connected ? 'Disconnect' : 'Connect'),
              ),
            ],
          )),
    );
  }
}

// https://medium.com/flutter-community/flutter-adding-bluetooth-functionality-1b9715ccc698
