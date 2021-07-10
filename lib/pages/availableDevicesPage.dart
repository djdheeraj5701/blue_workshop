import 'package:blue_workshop/pages/colorPalette.dart';
import 'package:blue_workshop/pages/globalVar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class AvailableDevicesPage extends StatefulWidget {
  @override
  _AvailableDevicesPageState createState() => _AvailableDevicesPageState();
}

class _AvailableDevicesPageState extends State<AvailableDevicesPage> {
  List pairedDevices=[];
  getPairedDevices()async{
    List tempDev;
    if(!(await bluetooth.isEnabled)){
      await bluetooth.requestEnable();return;
    }
    tempDev=await bluetooth.getBondedDevices();
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      pairedDevices=(tempDev!=null)?tempDev:pairedDevices;
    });
  }

  getConnectedTo(index)async{
    Letsconnect=!Letsconnect;
    selected_device=pairedDevices[index];
    connected_device=await BluetoothConnection.toAddress(selected_device.address);
  }

  getDisconnectedTo()async{
    connected_device.dispose();
    connected_device=null;
  }
  @override
  void initState(){
    onlyPortraitMode();
    super.initState();
  }

  deviceinfo(index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        decoration: myBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                  CupertinoIcons.bluetooth
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        customText(pairedDevices[index].name, 20),
                        customText(pairedDevices[index].address, 16),
                      ],
                    ),
                  )
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: pairedDevices[index].isConnected?
                    Colors.greenAccent.withOpacity(0.7):
                    Colors.redAccent.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorPalette.cp7,
                    width: 2,
                  ),
                ),
                // ignore: deprecated_member_use
                child: FlatButton(
                  onPressed: (){
                    pairedDevices[index].isConnected?
                    getDisconnectedTo():getConnectedTo(index);
                  },
                  child:
                  customText(
                      pairedDevices[index].isConnected? "Disconnect":"Connect",18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setscreensize(context);
    getPairedDevices();
    return WillPopScope(
      onWillPop: ()async{
        exitApp(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorPalette.cp6,
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            backgroundColor: ColorPalette.cp1,
            elevation: 10,
            shadowColor: Colors.blueAccent,
            title: customText("Available Devices",22),
            actions: [
              Tooltip(
                message: "add new devices",
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: GestureDetector(
                        onTap: ()async{
                          await bluetooth.openSettings();
                        },
                        child: Icon(CupertinoIcons.add,),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: "refresh",
                child: Padding(
                  padding: const EdgeInsets.only(right:20.0),
                  child: Container(
                    child: GestureDetector(
                      onTap: ()async{
                        getPairedDevices();
                      },
                      child: Icon(CupertinoIcons.refresh,),
                    ),
                  ),
                ),
              ),
            ],
            iconTheme: IconThemeData(color: ColorPalette.cp7,size: 26),
          ),
          drawer: myDrawer(context),
          body: SingleChildScrollView(
            child: Container(
                height: sh*0.95-100,
                child: pairedDevices.length==0?
                    Center(
                      child:
                      //CupertinoActivityIndicator(radius: 50,),
                      SpinKitFadingCircle(
                        color: ColorPalette.cp1,
                        size: 100,
                      ),
                    ):
                ListView.builder(
                    itemCount: pairedDevices.length,
                    itemBuilder: (context,index){
                      return deviceinfo(index);
                    },
                ),
              ),
          ),
        ),
      ),
    );
  }
}
