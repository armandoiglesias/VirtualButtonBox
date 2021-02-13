import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class BluetoothProvider {
  // static Database _database;

  BluetoothConnection _connection;
  BluetoothDevice _device;

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  List<BluetoothDevice> _devices;
  List<BluetoothDevice> get connectedDevices {
    return _devices;
  }

  BluetoothConnection get connection {
    return isConnected ? _connection : null;
  }

  bool get isConnected {
    return _device != null ? true : false;
  }

  static final BluetoothProvider btp = BluetoothProvider._();

  BluetoothProvider._();

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
        } else {}
      }
    });

    // It is an error to call [setState] unless [mounted] is true.

    this._devices = devices;
  }

  void disconnect() {
    final _connection = connection;
    _device = null;
    _connection.finish();
  }

  void connect(BluetoothDevice device) {
    if (device == null) {
      //show('No device selected');
    } else {
      bluetooth.isEnabled.then((isConnected) {
        // if (isConnected) {
        BluetoothConnection.toAddress(device.address)
            .then((BluetoothConnection response) {
          _device = device;
          _connection = response;
        });
      });
    }
  }

  void sendMessage(String mensaje) async {
    String _cadena = mensaje.toUpperCase();
    String _message = "* 00$_cadena#";
    // debugPrint(_message);
    if (_connection == null) {
      return;
    }

    _connection.output.add(utf8.encode(_message));
    await _connection.output.allSent;
    Vibration.vibrate(duration: 50, amplitude: 128);
  }
}
