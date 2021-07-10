import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colorPalette.dart';

// phone orientation modes
onlyLandscapeMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
onlyPortraitMode(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
allOrientationModes(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

double sh,sw,sm,sM;
setscreensize(context){
  sh=MediaQuery.of(context).size.height;
  sw=MediaQuery.of(context).size.width;
  sm=sh<sw?sh:sw;
  sM=sh<sw?sw:sh;
}

customText(s,fs){
  return Text(
    s,
    style: TextStyle(
        fontFamily: "josefinSans",
        color: ColorPalette.cp7,
      fontSize: fs+0.0
    ),
  );
}

exitApp(context){
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: customText("Do you wish to exit?",18),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    allOrientationModes();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      child: Text(
                        "Yes,Exit",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "josefinSans",
                            color: Colors.green
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      child: Text(
                        "No",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "josefinSans",
                            color: Colors.redAccent
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      }
  );
}

BTFirst(context)async{
  await showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: customText("Alert!",18),
          content: customText("Connect to a Bluetooth Module",18),
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.pushReplacementNamed(context, myDrawerList[1][2]);
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Ok",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "josefinSans",
                        color: Colors.green
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
  );
}


FlutterBluetoothSerial bluetooth=FlutterBluetoothSerial.instance;
bool Letsconnect=false;
BluetoothConnection connected_device=null;
BluetoothDevice selected_device;


// send(ascii.encode('ON'));
Future send(Uint8List data) async {
  connected_device.output.add(data);
  await connected_device.output.allSent;
}

Future receive()async{
  try{
    connected_device.input.listen((Uint8List data) {
      var temp=ascii.decode(data);
      print(temp);
      if(temp.contains("!")){
        return true;
      }
    });
  }catch(e){
    print(e);
  }
}


List myDrawerList=[
  [CupertinoIcons.home,"Home","/roboHome"],
  [CupertinoIcons.bluetooth,"Available Devices","/availableDevices"],
  [CupertinoIcons.scribble,"Gesture Controller","/gestureController"],
  [CupertinoIcons.smallcircle_fill_circle,"Servo Controller","/circularServoController"],
];
myDrawerContainer(context,index){
  return Padding(
    padding: const EdgeInsets.only(top:8.0,left:8.0,right:8.0),
    child: GestureDetector(
      onTap: (){
        Navigator.pushReplacementNamed(context, myDrawerList[index][2]);
      },
      child: Container(
        height: 60,width: sw,
        decoration: myBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(myDrawerList[index][0],color: ColorPalette.cp7,size: 28,),
            ),
            Expanded(child: Center(child: customText(myDrawerList[index][1], 22),),),
          ],
        ),
      ),
    ),
  );
}

launchEmail(mailaddress) async {
  await launch(
      "mailto:$mailaddress?subject=Via Blue Workshop&body=Hi,\n");
}

launchInstagram(instaid)async{
  await launch("https://www.instagram.com/$instaid/");
}

// "18.4575","73.8508" for PICT
launchMap(lat,lng) async {
  final String googleMapsUrl = "comgooglemaps://?center=$lat,$lng";
  final String appleMapsUrl = "https://maps.apple.com/?q=$lat,$lng";

  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
    return;
  }
  if (await canLaunch(appleMapsUrl)) {
    await launch(appleMapsUrl, forceSafariVC: false);return;
  } else {
    throw "Couldn't launch URL";
  }
}

SocialAccountClick(ic,clk,col){
  return Padding(
    padding: const EdgeInsets.only(right:18.0),
    child: GestureDetector(
      onTap: ()async=> await launch("https://www.$clk/pictrobotics/"),
      child: Icon(ic,
        color: col,),
    ),
  );
}

myBoxDecoration(){
  return BoxDecoration(
      color: ColorPalette.cp1,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
          color: ColorPalette.cp7,
          width:2
      )
  );
}

myDrawer(context){
  setscreensize(context);
  return Drawer(
    child: SafeArea(
      child: Column(
        children: [
          Container(
            width:sw,height: sh*0.3,
            decoration: BoxDecoration(
              color: ColorPalette.cp2.withOpacity(0.7),
            ),
            child: Stack(
              children: [
                Center(
                    child: Image(
                      image: AssetImage("assets/Badge_lightblue v1.png"),)),
                Container(
                  width: 50,
                  height: 50,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      exitApp(context);
                      },
                    child: Tooltip(
                      child: Icon(
                          CupertinoIcons.xmark,color: ColorPalette.cp1,size:32),
                      message: "Exit App",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width:sw,
              decoration: BoxDecoration(
                color: ColorPalette.cp6.withOpacity(0.7),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    myDrawerContainer(context,0),
                    myDrawerContainer(context,1),
                    myDrawerContainer(context,2),
                    myDrawerContainer(context,3),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: ColorPalette.cp2.withOpacity(0.7),
            child: Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: Container(
                width: sw,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Developed by",
                        style: TextStyle(
                          fontFamily: "josefinSans",
                          fontSize: 18,
                          color: Colors.blueGrey[100]
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Dheeraj Gonchigar",
                              style: TextStyle(
                                  fontFamily: "josefinSans",
                                  fontSize: 22,
                                  color: ColorPalette.cp1
                              ),
                            ),
                            Expanded(child: SizedBox(),),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: ()=> launchInstagram("dheeraj_gonchigar_5701"),
                                child: Icon(FontAwesomeIcons.instagram,
                                  color: ColorPalette.cp1,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: ()=>launchEmail("dheerajgonchigar5701@gmail.com"),
                                child: Icon(CupertinoIcons.mail,
                                    color: ColorPalette.cp1,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              )
            ),
          )
        ],
      ),
    ),
  );
}