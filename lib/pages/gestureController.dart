import 'dart:async';
import 'dart:convert';

import 'package:blue_workshop/pages/colorPalette.dart';
import 'package:blue_workshop/pages/globalVar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

class GestureControllerPage extends StatefulWidget {
  @override
  _GestureControllerPageState createState() => _GestureControllerPageState();
}

class _GestureControllerPageState extends State<GestureControllerPage> {
  bool isSharing=false;

  Timer timer;
  StreamSubscription accel;

  double ball_top=0,ball_left=0;
  AccelerometerEvent event=AccelerometerEvent(0,0,0);

  setPosition(AccelerometerEvent event) {
    if (event == null) {
      return;
    }
    setState(() {
      ball_top=((event.y*50)+sh/3);
      ball_top=(ball_top>sh*0.9-200)?sh*0.9-200:((ball_top<0)?0:ball_top);

      ball_left=((event.x*30)+sw/2.5);
      ball_left=(ball_left>sw-50)?sw-50:((ball_left<0)?0:ball_left);

      send(ascii.encode(
          event.x.toStringAsFixed(2)+" "+
          event.y.toStringAsFixed(2)+" "+
          event.z.toStringAsFixed(2)+"\n"
      ));
    });
  }

  void move_the_ball(){
    if(accel==null){
      accel=accelerometerEvents.listen((AccelerometerEvent ev) {
        setState(() {
          event=ev;
        });
      });
    }else{
      accel.resume();
    }
    if (timer == null || !timer.isActive) {
      timer = Timer.periodic(Duration(milliseconds: 100), (_) {
        if (!isSharing) {
          cancelTimer();
        } else {
          setPosition(event);
        }
      });
    }
  }

  cancelTimer() {
    timer?.cancel();
    accel?.cancel();
    timer=null;accel=null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(timer!=null && timer.isActive){
      cancelTimer();
    }
    isSharing=false;
  }
  @override
  void initState(){
    onlyPortraitMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setscreensize(context);
    return WillPopScope(
      onWillPop: ()async{
        exitApp(context);
        return false;
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 100,
              backgroundColor: ColorPalette.cp1,
              elevation: 10,
              shadowColor: Colors.blueAccent,
              title: customText("Gesture Controller",22),
              actions: [
                Tooltip(
                  message: "Send values",
                  child: Padding(
                    padding: const EdgeInsets.only(right:20.0),
                    child: Center(
                      child: Container(
                        height: 50,width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSharing?Colors.greenAccent:Colors.redAccent,
                        ),
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: (){
                            setState(() {
                              if(connected_device==null){
                                BTFirst(context);return;
                              }
                              isSharing=!isSharing;
                              if(accel==null || accel.isPaused){
                                move_the_ball();
                              }
                              else{
                                cancelTimer();
                              }
                            });
                          },
                          child: Center(
                            child: Icon(
                              isSharing?CupertinoIcons.share_solid:CupertinoIcons.share,
                              color: ColorPalette.cp7,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              iconTheme: IconThemeData(color: ColorPalette.cp7,size: 26),
            ),
              drawer: myDrawer(context),
            body: Stack(
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Container(
                    child: Image(
                      image: AssetImage(
                          "assets/Badge_blue v1.png"),
                      height: sM*0.9-100,width: sM*0.9-100,
                    ),
                  ),
                ),
                Positioned(
                  top:ball_top,right:ball_left,
                  child: Column(
                      children: [
                        Container(
                          height: 50,width: 50,
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: ColorPalette.cp7,
                              width: 2,
                            )
                          ),
                        ),
                        customText("x: "+event.x.toStringAsFixed(2),12),
                        customText("y: "+event.y.toStringAsFixed(2),12),
                        customText("z: "+event.z.toStringAsFixed(2),12),
                      ]
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
