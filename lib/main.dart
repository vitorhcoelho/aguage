import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(const MyApp());

  // // Some simplest connection :F
  // try {
  //     BluetoothConnection connection = await BluetoothConnection.toAddress(address);
  //     print('Connected to the device');

  //     connection.input.listen((Uint8List data) {
  //         print('Data incoming: ${ascii.decode(data)}');
  //         connection.output.add(data); // Sending data

  //         if (ascii.decode(data).contains('!')) {
  //             connection.finish(); // Closing connection
  //             print('Disconnecting by local host');
  //         }
  //     }).onDone(() {
  //       print('Disconnected by remote request');
  //     });
  // }
  // catch (exception) {
  //     print('Cannot connect, exception occured');
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aguage',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Aguage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
            },
          ),
          const Divider(),
          Text(isSwitched ? 'Bomba ligada' : 'Bomba desligada')
        ],
      ),
    );
  }
}
