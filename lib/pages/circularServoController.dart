import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'colorPalette.dart';
import 'globalVar.dart';

class CircularServoController extends StatefulWidget {
  @override
  _CircularServoControllerState createState() => _CircularServoControllerState();
}

class _CircularServoControllerState extends State<CircularServoController> {
  bool isSharing=false;
  bool oneactive=false;
  double value=0;
  onValueChanged(double val)async{
    if(value==val.roundToDouble()) return;
    await Future.delayed(Duration(milliseconds: 1));
    setState(() {
      value=val.roundToDouble();
      send(ascii.encode(value.toStringAsFixed(0)+" \n"));
      print(value.toStringAsFixed(0));
    });
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
              title: customText("Servo Controller",22),
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
                Positioned(
                  top: 50,left: 5,
                  bottom: 50,right: 5,
                  child: Container(
                    height: sM*0.9-100,width: sM*0.9-100,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(minimum: 0,
                          maximum: 360,
                          startAngle: 270,
                          endAngle: 270,
                          showLabels: false,
                          showTicks: true,
                          axisLineStyle: AxisLineStyle(
                              cornerStyle: CornerStyle.bothFlat,
                              color: ColorPalette.cp6.withOpacity(0.2),
                              thickness: 25
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: value,
                              cornerStyle: CornerStyle.bothFlat,
                              width: 25,
                              sizeUnit: GaugeSizeUnit.factor,
                                gradient: SweepGradient(
                                    colors: <Color>[
                                      ColorPalette.cp6,
                                      ColorPalette.cp5,
                                      ColorPalette.cp4,
                                    ],
                                    stops: <double>[0.25,0.5, 0.75]
                                )
                            ),
                            MarkerPointer(
                              value: value,
                              enableDragging: isSharing,
                              onValueChanged: onValueChanged,
                              markerHeight: 25,
                              markerWidth: 25,
                              markerType: MarkerType.circle,
                              borderColor: ColorPalette.cp2,
                              borderWidth: 5,
                              color: ColorPalette.cp1,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: (sM*0.8-100)/2,left: (sm*0.8-100)/2,
                  bottom: (sM*0.8-100)/2,right: (sm*0.8-100)/2,
                  child: GestureDetector(
                    onLongPress: ()async{
                      if(!isSharing) return;
                      if(oneactive)return;
                      oneactive=true;
                      while(value<360){
                        onValueChanged(value+1.0);
                        await Future.delayed(Duration(milliseconds: 1));// delay matters in sending receiving
                      }
                      oneactive=false;
                    },
                    onTap: ()async{
                      if(!isSharing) return;
                      if(oneactive)return;
                      oneactive=true;
                      while(value>0){
                        onValueChanged(value-1.0);
                        await Future.delayed(Duration(milliseconds: 1));
                      }
                      oneactive=false;
                    },
                    child: Container(
                      // height: sM*0.9-100,width: sM*0.9-100,
                      child: Image(
                        image: AssetImage(
                            "assets/Badge_blue v1.png",),
                        height: 100,width: 100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
