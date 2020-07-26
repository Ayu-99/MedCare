import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medcare/Screens/Dashboard/MainDrawer.dart';
import 'package:medcare/Screens/Dashboard/MedicinesList.dart';
import 'package:medcare/Screens/Dashboard/viewCart.dart';
import 'package:medcare/Services/auth.dart';
import 'package:medcare/Services/database.dart';
import 'package:medcare/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  String email;
  Home(String email) {
    this.email = email;
  }
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final AuthService _auth = AuthService();
  String title, categoryUid;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void askToLogout(BuildContext context) {
    var alertDialog = (AlertDialog(
      title: Text("Are you sure you want to logout?"),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("NO"),
        ),
        FlatButton(
          onPressed: () {
            auth.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/welcomeScreen', (Route<dynamic> route) => false);
          },
          child: Text("YES"),
        ),
      ],
    ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().Categories,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(widget.email),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return ViewCart();
                }));
              },
            ),
            SizedBox(
              width: 3.0,
            ),
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                askToLogout(context);
              },
            ),
          ],
          elevation: 50,
          title: Text(
            "Choose Category",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: Firestore.instance.collection("category").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return Loading();
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: snapshot.data.documents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                childAspectRatio: .25 * 3,
              ),
              itemBuilder: (context, index) {
                DocumentSnapshot category = snapshot.data.documents[index];
                return SelectCategory(category.data['name'],
                    category.data['imageUrl'], category.data['uid']);
              },
            );
          },
        ),
      ),
    );
  }
}

class SelectCategory extends StatelessWidget {
  String title, imageUrl, categoryUid;

  SelectCategory(String title, String imageUrl, String uid) {
    this.title = title;
    this.imageUrl = imageUrl;
    this.categoryUid = uid;
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MedicinesList(this.title),
        ));
      },
      child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Column(
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  this.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
