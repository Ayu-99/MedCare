import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medcare/Screens/Dashboard/AboutScreen.dart';
import 'package:medcare/Screens/Dashboard/PlaceOrder.dart';
import 'package:medcare/Screens/Dashboard/Suggestion.dart';
import 'package:medcare/Screens/Dashboard/in-store-orders.dart';
import 'package:medcare/Screens/Dashboard/out-stock-orders.dart';
import 'package:medcare/Screens/Dashboard/viewCart.dart';
import 'package:medcare/Services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medcare/Services/database.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer(String email){
//    this.email=db.getEmail(uid1);
  }

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  DatabaseService db=new DatabaseService();
  String title,email;
  SharedPreferences prefs;
  AuthService a=new AuthService();




  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseUser user;

   getUid() async{
    user = await _auth.currentUser();
    this.email=user.email;
    print(this.email);
    return user;
  }

  @override
  void initState(){
    // TODO: implement initState

    print(getUid());

  }
  FirebaseAuth auth=FirebaseAuth.instance;

  String uid1;

  void uidOfUser() async {
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
    // here you write the codes to input the data into firestore
  }

  void askToLogout(BuildContext context){
    var alertDialog=(AlertDialog(
      title:Text("Are you sure you want to logout?"),
      actions: [
        FlatButton(
          onPressed: (){
            Navigator.of(context).pop(false);
          },
          child: Text("NO"),
        ),
        FlatButton(
          onPressed: (){
            auth.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil('/welcomeScreen', (Route<dynamic> route) => false);
          },
          child: Text("YES"),
        ),
      ],



    ));
    showDialog(context: context,builder: (BuildContext context){
      return alertDialog;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top:30,bottom: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/user.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),

                  ),
                  Text(email,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                ],
              ),
            ),
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return ViewCart();
                  }));
            },
            leading: Icon(Icons.shopping_cart),
            title:Text("My cart",style: TextStyle(
              fontSize: 18,
            ),)
          ),
          ListTile(

              leading: Icon(Icons.shopping_basket),
              title:Text("My in-stock orders",style: TextStyle(
                fontSize: 18,
              ),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return InStoreOrders();
                  }));
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title:Text("My out-stock orders",style: TextStyle(
              fontSize: 18,
            ),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return OutStoreOrders();
                  }));
            },
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return PlaceOrder();
              }));},
              leading: Icon(Icons.add_shopping_cart),
              title:Text("Place an order",style: TextStyle(
                fontSize: 18,
              ),)
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return About();
                  }));
            },
              leading: Icon(Icons.account_box),
              title:Text("About Us",style: TextStyle(
                fontSize: 18,
              ),)
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return Suggestion();
                  }));
            },
              leading: Icon(Icons.message),
              title:Text("Write us a suggestion",style: TextStyle(
                fontSize: 18,
              ),)
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            onTap:(){
              askToLogout(context);
            },
              leading: Icon(Icons.power_settings_new),
              title:Text("Logout",style: TextStyle(
                fontSize: 18,
              ),)
          ),

        ],
      ),

    );
  }
}
