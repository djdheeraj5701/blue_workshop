import 'package:blue_workshop/pages/colorPalette.dart';
import 'package:blue_workshop/pages/globalVar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RoboHomePage extends StatefulWidget {
  @override
  _RoboHomePageState createState() => _RoboHomePageState();
}

class _RoboHomePageState extends State<RoboHomePage> {
  String intro=
      "PICT Robotics team takes part in the annual Asia-Pacific Robot Contest (ABU Robocon), founded in 2002 by Asia-Pacific Broadcasting Union. PICT Robotics aims to enhance the technical skills of the team members as well as gives them exposure to competitions at an international level. Moreover, the team members gain industrial experience in the fields of mechatronics and hardcore coding.";

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
          backgroundColor: ColorPalette.cp6,
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            backgroundColor: ColorPalette.cp1,
            elevation: 10,
            shadowColor: Colors.blueAccent,
            title: customText("Home",22),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:18.0),
                child: GestureDetector(
                  onTap: ()=> launch("https://pictrobotics.com"),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.globe,
                        color: Colors.blueGrey[700],),
                      customText("www.",18)
                    ],
                  ),
                ),
              )
            ],
            iconTheme: IconThemeData(color: ColorPalette.cp7,size: 26),
          ),
          drawer: myDrawer(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:8.0,left:8.0,right:8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: sw/1.72+200,width: sw,
                    decoration: myBoxDecoration(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: ()async=>await launch("https://pictrobotics.com/workshop/index.html"),
                              child: Container(
                                height: sw/1.72,width: sw,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/sl2.png"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child:Text(
                                    intro,
                                  style: TextStyle(
                                      fontFamily: "josefinSans",
                                      color: ColorPalette.cp7,
                                    fontSize: 18,
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 70,width: sw,
                    decoration: myBoxDecoration(),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Icon(
                              CupertinoIcons.mail
                          ),
                        ),
                        Center(child:customText("Email us",22)),
                        Expanded(child: SizedBox()),
                        Center(child:customText("robocon@pict.edu",22)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: ()=>launchEmail("robocon@pict.edu"),
                            child: Icon(FontAwesomeIcons.shareSquare,
                              color: ColorPalette.cp7,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 70,width: sw,
                    decoration: myBoxDecoration(),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Icon(
                              FontAwesomeIcons.link
                          ),
                        ),
                        Center(child:customText("Follow us",22)),
                        Expanded(child: SizedBox()),
                        SocialAccountClick(
                          FontAwesomeIcons.instagram,
                          "instagram.com",Colors.pinkAccent
                        ),
                        SocialAccountClick(
                          FontAwesomeIcons.linkedin,
                          "linkedin.com/company",Colors.lightBlueAccent
                        ),
                        SocialAccountClick(
                            FontAwesomeIcons.facebook,
                            "facebook.com",Colors.blueAccent
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: 400,width: sw,
                    decoration: myBoxDecoration(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  CupertinoIcons.location_solid,color: Colors.redAccent,
                              ),
                              Center(child:customText("Visit us",22)),
                            ],
                          ),
                        ),
                        Center(
                            child:
                            customText(
                                "Survey No. 27, Near Trimurti Chowk,",
                                14),),
                        Center(
                          child:
                          customText(
                              "Bharati Vidyapeeth Campus,Dhankawadi,",
                              14),),
                        Center(
                          child:
                          customText(
                              "Pune,Maharashtra 411043",
                              14),),
                        GestureDetector(
                          onTap: ()=>launchMap("18.4575","73.8508"),
                          child: Image(
                            image: AssetImage("assets/gmaploc.png"),height: 280,width: sw,),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
