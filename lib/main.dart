import 'package:flutter/material.dart';
import 'package:medcare/Admin/Screens/Dashboard.dart';
import 'package:medcare/Screens/Dashboard/AboutScreen.dart';
import 'package:medcare/Screens/Dashboard/MedicinesList.dart';
import 'package:medcare/Screens/Dashboard/PlaceOrder.dart';
import 'package:medcare/Screens/Dashboard/home.dart';
import 'package:medcare/Screens/Login/components/body.dart';
import 'package:medcare/Screens/Signup/signup_screen.dart';
import 'package:medcare/Screens/Welcome/components/body.dart';
import 'package:medcare/Screens/Welcome/welcome_screen.dart';
import 'package:medcare/Services/auth.dart';
import 'package:medcare/splashScreen.dart';
import 'constants.dart';
import 'package:medcare/models/user.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: SplashScreen(),
        routes: {
//          '/homeScreen':(context)=> Home(""),
          '/SignInScreen':(context)=>SignUpScreen(),
          '/welcomeScreen':(context)=>WelcomeScreen(),
        },
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
//    print(user);
    if (user == null) {

      return WelcomeScreen();

    } else {

//      return DashBoard();
      return Home("");
    }
  }
}

