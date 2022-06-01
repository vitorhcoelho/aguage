// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:aguage/device.dart';
import 'package:aguage/globals.dart' as globals;


void main() {
  runApp(FlutterBlueApp());
}

String printBluetoothStatus (String text) {
  if(text == "off") return 'Ligue o bluetooth para continuar';
  else return '';
}

String deviceStatusLabel (String text){
  if(text == "connected") return 'conectado';
   else return 'desconectado';
}

void verifyConnected(deviceObj, isConnected){
  const colocarOBreackpointNessaLinha = '';
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: globals.mainColor,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.mainColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: globals.textColor,
            ),
            Text(
              '${state != null ? printBluetoothStatus(state.toString().substring(15)) : 'Não disponível'}.',
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione o Irriguage Max'),
        backgroundColor: globals.mainColor,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: globals.textColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map((result) => ListTile(
                          title: Text(result.device.name == "" ? "Sem nome " : result.device.name),
                          subtitle: Text(result.device.id.toString()),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            result.device.connect();
                            return DeviceScreen(device: result.device);
                          })),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: Icon(Icons.stop, color: globals.mainColor,),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: globals.textColor,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search, color: globals.textColor,), 
                onPressed: () => FlutterBlue.instance.startScan(timeout: Duration(seconds: 10)),
                backgroundColor: globals.mainColor,
              );
          }
        },
      ),
    );
  }
}