import 'package:blue_workshop/pages/availableDevicesPage.dart';
import 'package:blue_workshop/pages/circularServoController.dart';
import 'package:blue_workshop/pages/gestureController.dart';
import 'package:blue_workshop/pages/openingPage.dart';
import 'package:blue_workshop/pages/roboHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      "/roboHome":(context)=>RoboHomePage(),
      "/availableDevices":(context)=>AvailableDevicesPage(),
      "/gestureController":(context)=>GestureControllerPage(),
      "/circularServoController":(context)=>CircularServoController(),
    },
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context,future){
          if(future.connectionState==ConnectionState.waiting){
            return OpeningPage();
          }else{
            return RoboHomePage();
          }
        }
    );
  }
}