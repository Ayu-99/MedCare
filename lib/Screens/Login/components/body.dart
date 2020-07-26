import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medcare/Screens/Dashboard/home.dart';
import 'package:medcare/Screens/Login/components/background.dart';
import 'package:medcare/Screens/Login/login_screen.dart';
import 'package:medcare/Screens/Signup/signup_screen.dart';
import 'package:medcare/Services/auth.dart';
import 'package:medcare/components/already_have_an_account_acheck.dart';
import 'package:medcare/components/rounded_button.dart';
import 'package:medcare/components/rounded_input_field.dart';
import 'package:medcare/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/loading.dart';
import 'package:medcare/constants.dart';

class Body extends StatefulWidget {
  Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email,pswd;

  bool loading=false;

  FirebaseAuth auth=FirebaseAuth.instance;
  final AuthService _auth=AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading?Loading():Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset("assets/icons/login.svg",
                height: size.height * 0.35),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                email=value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                pswd=value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                if (email == null || email == "") {
                  Fluttertoast.showToast(
                      msg: "Email cannot be empty!!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: kPrimaryLightColor,
                      textColor: Colors.black,
                      fontSize: 16.0
                  );
                }
                else if (pswd == null || pswd == "") {
                  Fluttertoast.showToast(
                      msg: "Password cannot be empty!!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: kPrimaryLightColor,
                      textColor: Colors.black,
                      fontSize: 16.0
                  );
                }
                else if (pswd.length < 6) {
                  Fluttertoast.showToast(
                      msg: "Password should be atlest 6 characters long!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: kPrimaryLightColor,
                      textColor: Colors.black,
                      fontSize: 12.0
                  );
                }else{
                  setState(()=>loading=true);


                  dynamic result=_auth.signInWithEmailAndPassword(email, pswd);


                  setState(() {
                    loading=false;
                  });
//                  print("REsult"+result);
                  if(result!=null){

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Home(email);
                        },
                      ),
                    );

                  }else{

                    Fluttertoast.showToast(
                        msg: "Error in Signing In..Try Again!!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent[100],
                        textColor: Colors.white,
                        fontSize: 12.0
                    );
//                    Navigator.of(context).pushNamedAndRemoveUntil("/homeScreen", (route) => false);
                  }
                }

              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
