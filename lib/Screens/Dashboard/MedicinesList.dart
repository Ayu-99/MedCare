import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/Screens/Dashboard/BuyDetails.dart';
import 'package:medcare/Screens/Dashboard/Suggestion.dart';
import 'package:medcare/Services/database.dart';
import 'package:medcare/loading.dart';
import 'dart:async';

class MedicinesList extends StatefulWidget {
  String categoryName;

  MedicinesList(String categoryName) {
    this.categoryName = categoryName;
  }
  @override
  _MedicinesListState createState() => _MedicinesListState();
}

class _MedicinesListState extends State<MedicinesList> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid1;
  List<String> medicinesName = new List();
  List<String> medicinesPrice = new List();
  List<String> medicinesImageUrl = new List();
  List<String> medicinesCategory = new List();
  List<String> medicinesUid = new List();

  DatabaseService db=new DatabaseService();

  void uidOfUser() async {
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
    // here you write the codes to input the data into firestore
  }



  Future getMedicines() async {
    print("category uid" + widget.categoryName);
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection("medicines")
        .where('category', isEqualTo: widget.categoryName)
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: DataSearch(medicinesName, medicinesPrice,
                      medicinesCategory, medicinesImageUrl, medicinesUid));
            },
          )
        ],
        elevation: 50,
        title: Text(
          "Choose Medicine",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getMedicines(),
        builder: (context, snapshot) {
          if (snapshot.data == null ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                medicinesName.add(snapshot.data[index].data['name']);
                medicinesPrice.add(snapshot.data[index].data['price']);
                medicinesUid.add(snapshot.data[index].data['uid']);
                medicinesImageUrl.add(snapshot.data[index].data['imageUrl']);
                medicinesCategory.add(snapshot.data[index].data['category']);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return BuyDetails(
                          uid1,
                          snapshot.data[index].data['uid'],
                          snapshot.data[index].data['name'],
                          snapshot.data[index].data['price'],
                          snapshot.data[index].data['imageUrl'],
                          snapshot.data[index].data['category']);
                    }));
                  },
                  child: Card(
                    margin: EdgeInsets.all(15.0),
                    elevation: 15.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    snapshot.data[index].data['imageUrl'],
                                    width: 100,
                                    height: 100,
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "NAME:  " +
                                            snapshot.data[index].data['name'],
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "PRICE:  ₹" +
                                            snapshot.data[index].data['price'],
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 50.0,
                            ),
                            RaisedButton.icon(
                              elevation: 5.0,
                              onPressed: () async {
                                final FirebaseUser user =
                                    await auth.currentUser();
                                uid1 = user.uid.toString();
                                DatabaseService db = new DatabaseService();
                                var result = db.addToCart(
                                    uid1,
                                    snapshot.data[index].data['uid'],
                                    snapshot.data[index].data['name'],
                                    snapshot.data[index].data['price'],
                                    snapshot.data[index].data['imageUrl'],
                                    snapshot.data[index].data['category']);

                                print(result);

                                if (result == null) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Error in adding to cart..Try Again!!",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.redAccent[100],
                                      textColor: Colors.white,
                                      fontSize: 24.0);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Added to Cart",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 24.0);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              label: Text(
                                'Add to Cart',
                                style: TextStyle(color: Colors.black),
                              ),
                              icon: Icon(
                                Icons.shopping_cart,
                                color: Colors.black,
                              ),
                              textColor: Colors.black,
                              color: Colors.white,
                              splashColor: Colors.lightBlue[100],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            RaisedButton.icon(
                              elevation: 10.0,
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return BuyDetails(
                                      uid1,
                                      snapshot.data[index].data['uid'],
                                      snapshot.data[index].data['name'],
                                      snapshot.data[index].data['price'],
                                      snapshot.data[index].data['imageUrl'],
                                      snapshot.data[index].data['category']);
                                }));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              label: Text(
                                'Buy Now',
                                style: TextStyle(color: Colors.black),
                              ),
                              icon: Icon(
                                Icons.shopping_basket,
                                color: Colors.black,
                              ),
                              textColor: Colors.black,
                              color: Colors.white,
                              splashColor: Colors.lightBlue[100],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class DataSearch extends SearchDelegate<String> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid1;
  void uidOfUser() async {
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
    // here you write the codes to input the data into firestore
  }

  List<String> medicinesName;
  List<String> medicinesPrice;
  List<String> medicinesCategory;
  List<String> medicinesImageUrl;
  List<String> medicinesUid;
  DataSearch(
      List<String> medicinesName,
      List<String> medicinesPrice,
      List<String> medicinesCategory,
      List<String> medicinesImageUrl,
      List<String> medicinesUid) {
    this.medicinesName = medicinesName;
    this.medicinesPrice = medicinesPrice;
    this.medicinesCategory = medicinesCategory;
    this.medicinesImageUrl = medicinesImageUrl;
    this.medicinesUid = medicinesUid;
  }

  List<String> recents = ["Disperin", "Dolo", "Nepamed"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container(
      height: 100,
      width: 100,
      child: Card(
        color: Colors.red,
        shape: StadiumBorder(),
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
//    query="";
    final suggestionList = query.isEmpty
        ? medicinesName
        : medicinesName
            .where((element) => element.startsWith(query.capitalize()))
            .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          int i = medicinesName.indexOf(suggestionList[index]);
          return GestureDetector(
            onTap: () {
              uidOfUser();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BuyDetails(
                    uid1,
                    medicinesUid[i],
                    medicinesName[i],
                    medicinesPrice[i],
                    medicinesImageUrl[i],
                    medicinesCategory[i]);
              }));
            },
            child: Card(
              margin: EdgeInsets.all(15.0),
              elevation: 15.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.network(
                              medicinesImageUrl[i],
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: suggestionList[index]
                                        .substring(0, query.length),
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0
                                    ),
                                    children: [
                                      TextSpan(
                                        text: suggestionList[index]
                                            .substring(query.length),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "PRICE:  ₹" + medicinesPrice[i],
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                      ),
                      RaisedButton.icon(
                        elevation: 5.0,
                        onPressed: () async {
                          final FirebaseUser user = await auth.currentUser();
                          uid1 = user.uid.toString();
                          DatabaseService db = new DatabaseService();
                          var result = db.addToCart(
                              uid1,
                              medicinesUid[i],
                              medicinesName[i],
                              medicinesPrice[i],
                              medicinesImageUrl[i],
                              medicinesCategory[i]);

                          print(result);

                          if (result == null) {
                            Fluttertoast.showToast(
                                msg: "Error in adding to cart..Try Again!!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.redAccent[100],
                                textColor: Colors.white,
                                fontSize: 24.0);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Added to Cart",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 24.0);
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        label: Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                        ),
                        textColor: Colors.black,
                        color: Colors.white,
                        splashColor: Colors.lightBlue[100],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      RaisedButton.icon(
                        elevation: 10.0,
                        onPressed: () {
                          uidOfUser();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return BuyDetails(
                                uid1,
                                medicinesUid[i],
                                medicinesName[i],
                                medicinesPrice[i],
                                medicinesImageUrl[i],
                                medicinesCategory[i]);
                          }));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        label: Text(
                          'Buy Now',
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: Icon(
                          Icons.shopping_basket,
                          color: Colors.black,
                        ),
                        textColor: Colors.black,
                        color: Colors.white,
                        splashColor: Colors.lightBlue[100],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

//ListView.builder(
//itemCount:suggestionList.length,
//itemBuilder: (context,index)=>ListTile(
//onTap: (){
//showResults(context);
//},
//
//leading: Icon(Icons.location_city),
//title:RichText(
//text: TextSpan(
//text: suggestionList[index].substring(0,query.length),
//style: TextStyle(
//color:Colors.black,
//fontWeight:FontWeight.bold,
//),
//children: [
//TextSpan(
//text: suggestionList[index].substring(query.length),
//style: TextStyle(color: Colors.grey),
//),
//],
//),
//),
//
//));
