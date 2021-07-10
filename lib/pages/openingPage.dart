import 'package:blue_workshop/pages/colorPalette.dart';
import 'package:blue_workshop/pages/globalVar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpeningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setscreensize(context);
    return Scaffold(
      body: Container(
        height:double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorPalette.cp6,
              ColorPalette.cp5,
              ColorPalette.cp2.withOpacity(0.8),
              ColorPalette.cp3.withOpacity(0.8),
            ]
          )
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: sm,width: sm,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sm/2),
                    boxShadow: [
                      BoxShadow(
                      color: ColorPalette.cp3.withOpacity(0.3),
                          blurRadius: sm/1.8
                    ),
                    ],
                    color: ColorPalette.cp2.withOpacity(0.4),
                ),
              ),
              Container(
                height: sm/1.25,width: sm/1.25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sm/2.5),
                    boxShadow: [
                      BoxShadow(
                          color: ColorPalette.cp5.withOpacity(0.9),
                        blurRadius: sm/2.6
                      ),
                    ],
                    color: ColorPalette.cp5
                ),
              ),
              Container(
                height: sm/1.5,width: sm/1.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sm/3),
                    boxShadow: [
                      BoxShadow(
                          color: ColorPalette.cp6.withOpacity(0.9),
                          blurRadius: sm/3.2
                      ),
                    ],
                    color: ColorPalette.cp6.withOpacity(0.8),
                ),
              ),
              Container(
              height: sm/2,width: sm/2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sm/4),
                color: ColorPalette.cp1
              ),
              child: Icon(
                Icons.bluetooth_disabled,
                size: 100,
                color: ColorPalette.cp2.withOpacity(0.8),
              ),
            ),
          ]
          ),
        ),
      ),
    );
  }
}