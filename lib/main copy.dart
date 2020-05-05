// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:vibration/vibration.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Virtual Button Box',
//       theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // Try running your application with "flutter run". You'll see the
//           // application has a blue toolbar. Then, without quitting the app, try
//           // changing the primarySwatch below to Colors.green and then invoke
//           // "hot reload" (press "r" in the console where you ran "flutter run",
//           // or simply save your changes to "hot reload" in a Flutter IDE).
//           // Notice that the counter didn't reset back to zero; the application
//           // is not restarted.
//           primarySwatch: Colors.blue),
//       home: MyHomePage(title: 'Virtual Button Box'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
//   final FlutterBlue flutterBlue = FlutterBlue.instance;
//   final List<BluetoothCharacteristic> _characteristics =
//       new List<BluetoothCharacteristic>();

//   List<ButtonBox> getButtonBox() {
//     List<ButtonBox> listado = new List<ButtonBox>();
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_down),
//         character: "a",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_mute),
//         character: "b",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_up),
//         character: "c",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_off),
//         character: "d",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_down),
//         character: "e",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_off),
//         character: "f",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_down),
//         character: "g",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_mute),
//         character: "h",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_up),
//         character: "i",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_off),
//         character: "j",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_down),
//         character: "k",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_off),
//         character: "l",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_down),
//         character: "m",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_mute),
//         character: "n",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_up),
//         character: "o",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_off),
//         character: "p",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_down),
//         character: "q",
//         ));
//     listado.add(ButtonBox(
//         icon: Icon(Icons.volume_off),
//         character: "r",
//         ));

//     return listado;
//   }

//   @override
//   _MyHomePageState createState() => _MyHomePageState(listado: getButtonBox());
// }

// class ButtonBox extends StatelessWidget {
//   final Icon icon;
//   final String character;
//   // final BluetoothCharacteristic characteristic;

//   ButtonBox({this.icon, this.character});

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return IconButton(
//         icon: icon,
//         tooltip: character,
//         onPressed: () async {
//           //if (await Vibration.hasVibrator()) {
//           //Vibration.vibrate();
//           Vibration.vibrate(duration: 300, amplitude: 128);
//           // characteristic.write(utf8.encode(character));

//           //}
// //             flutterBlue.isAvailable.then( () => {
// //                 flutterBlue.
// // character.substring(0, 1).toUpperCase();

// //             })
//         });
//   }
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   final List<ButtonBox> listado;

//   BluetoothDevice _connectedDevice;
//   List<BluetoothService> _services;

//   _MyHomePageState({this.listado});

//   _addDeviceTolist(final BluetoothDevice device) {
//     if (!widget.devicesList.contains(device)) {
//       setState(() {
//         widget.devicesList.add(device);
//       });
//     }
//   }

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//     ]);
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.bluetooth),
//               onPressed: () {
//                 widget.flutterBlue.connectedDevices
//                     .asStream()
//                     .listen((List<BluetoothDevice> devices) {
//                   for (BluetoothDevice device in devices) {
//                     _addDeviceTolist(device);
//                   }
//                 });
//                 widget.flutterBlue.scanResults
//                     .listen((List<ScanResult> results) {
//                   for (ScanResult result in results) {
//                     _addDeviceTolist(result.device);
//                   }
//                   _showDialog();
//                 });
//                 widget.flutterBlue.startScan();
//               })
//         ],
//       ),
//       body: GridView.count(
//         primary: false,
//         padding: const EdgeInsets.all(10),
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         crossAxisCount: 2,
//         children: <Widget>[
//           Container(
//             padding: const EdgeInsets.all(8),
//             child: GridView.count(
//                 primary: false,
//                 padding: const EdgeInsets.all(2),
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 crossAxisCount: 2,
//                 children:
//                     // <Widget>[
//                     this
//                         .listado
//                         .take(4)
//                         .map((listado) => Container(
//                               padding: const EdgeInsets.all(8),
//                               child: listado,
//                               color: Colors.teal[100],
//                             ))
//                         .toList()),
//             color: Colors.teal[100],
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             child: GridView.count(
//                 primary: false,
//                 padding: const EdgeInsets.all(10),
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 crossAxisCount: 3,
//                 children: this
//                     .listado
//                     .skip(4)
//                     .take(9)
//                     .map((listado) => Container(
//                           padding: const EdgeInsets.all(8),
//                           child: listado,
//                           color: Colors.teal[100],
//                         ))
//                     .toList()),
//             color: Colors.teal[200],
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   ListView _buildListViewofDevices() {
//     List<Container> cantainers = new List<Container>();
//     for (BluetoothDevice device in widget.devicesList) {
//       cantainers.add(Container(
//         height: 50,
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 children: <Widget>[
//                   Text(device.name == '' ? "(Unknown Device)" : device.name),
//                   Text(device.id.toString())
//                 ],
//               ),
//             ),
//             FlatButton(
//               color: Colors.blue,
//               child: Text("Connect", style: TextStyle(color: Colors.white)),
//               onPressed: () {
//                 setState(() async {
//                   widget.flutterBlue.stopScan();
//                   try {
//                     await device.connect();
//                   } catch (e) {
//                     if (e.code != 'already_connected') {
//                       throw e;
//                     }
//                   } finally {
//                     _services = await device.discoverServices();
//                   }
//                   _connectedDevice = device;
//                 });
//               },
//             ),
//           ],
//         ),
//       ));
//     }

//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         ...cantainers,
//       ],
//     );
//   }

//   ListView _buildView() {
//     if (_connectedDevice != null) {
//       return _buildConnectDeviceView();
//     }
//     return _buildListViewofDevices();
//   }

//   ListView _buildConnectDeviceView() {
//     List<Container> containers = new List<Container>();

//     for (BluetoothService service in _services) {
//       List<Widget> characteristicsWidget = new List<Widget>();
//       for (BluetoothCharacteristic characteristic in service.characteristics) {
//         characteristic.value.listen((value) {
//           print(value);
//         });
//         characteristicsWidget.add(
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Text(characteristic.uuid.toString(),
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     ..._buildReadWriteNotifyButton(characteristic),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ),
//         );
//       }
//       containers.add(
//         Container(
//           child: ExpansionTile(
//               title: Text(service.uuid.toString()),
//               children: characteristicsWidget),
//         ),
//       );
//     }

//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         ...containers,
//       ],
//     );
//   }

//   _showDialog() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
          
//           return Dialog(

//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0)
//                   ), //this right here
//               child: Container(
//                 height: 200,
//                 child: Padding(
//                     padding: const EdgeInsets.all(12.0), child: _buildView()),
//               ) 
//               );
//         }) ?? Navigator.of(context).pop();
//   }

//   List<ButtonTheme> _buildReadWriteNotifyButton(
//       BluetoothCharacteristic characteristic) {
//     List<ButtonTheme> buttons = new List<ButtonTheme>();

//     // if (characteristic.properties.read) {
//     //   buttons.add(
//     //     ButtonTheme(
//     //       minWidth: 10,
//     //       height: 20,
//     //       child: Padding(
//     //         padding: const EdgeInsets.symmetric(horizontal: 4),
//     //         child: RaisedButton(
//     //           color: Colors.blue,
//     //           child: Text('READ', style: TextStyle(color: Colors.white)),
//     //           onPressed: () {},
//     //         ),
//     //       ),
//     //     ),
//     //   );
//     // }

//     if (characteristic.properties.write) {
//       widget._characteristics[0] = characteristic;
//       buttons.add(
//         ButtonTheme(
//           minWidth: 10,
//           height: 20,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: RaisedButton(
//               child: Text('WRITE', style: TextStyle(color: Colors.white)),
//               onPressed: () {
//                 characteristic.write( utf8.encode("L") );
//               },
//             ),
//           ),
//         ),
//       );
//     }
//     // if (characteristic.properties.notify) {
//     //   buttons.add(
//     //     ButtonTheme(
//     //       minWidth: 10,
//     //       height: 20,
//     //       child: Padding(
//     //         padding: const EdgeInsets.symmetric(horizontal: 4),
//     //         child: RaisedButton(
//     //           child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
//     //           onPressed: () {},
//     //         ),
//     //       ),
//     //     ),
//     //   );
//     // }

//     return buttons;
//   }
// }

// // https://blog.kuzzle.io/communicate-through-ble-using-flutter