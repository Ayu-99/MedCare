import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medcare/loading.dart';
import 'constants.dart';
import 'dart:async';
import 'package:medcare/main.dart';

class SplashScreen extends StatefulWidget {



  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),()=>Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return Wrapper();
      }
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 90.0,
                      child: Image.asset("assets/images/logo.png"),

                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10.0),

                    ),
                    Text(
                      "MedCare",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[500],
                        fontSize: 24,
                      ),
                    ),


                  ],
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loading(),
                  Padding(
                    padding: EdgeInsets.only(top:30.0),
                  ),

                  Text("Your medicines, at your door step!!!",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0

                  ),),
                ],
              ),
            )

          ],
        )
      ],
    )
    );
  }
}
