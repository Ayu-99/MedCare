import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/Screens/Dashboard/BuyDetails.dart';
import 'package:medcare/Services/database.dart';
import 'package:medcare/loading.dart';

class ViewCart extends StatefulWidget {
  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseService db=new DatabaseService();
  List<String> coupons=new List();
  String uid1;
  @override
  void initState() {
    // TODO: implement initState
  }

  Future getCartItems() async {
    var firestore = Firestore.instance;
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
    QuerySnapshot qn = await firestore
        .collection("users")
        .document(uid1)
        .collection("cart")
        .getDocuments();
    return qn.documents;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50,
        title: Text(
          "My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.data == null ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(snapshot.data[index].data['uid']),
                    onDismissed: (direction){
                        var result=db.removeFromCart(uid1, snapshot
                            .data[index].data['uid']);
                        if(result!=null){
                          print("deleted");
                        }
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
                                              snapshot
                                                  .data[index].data['price'],
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
                                width: 160.0,
                              ),
                              RaisedButton.icon(
                                elevation: 10.0,
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
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
        },
      ),
    );
  }
}
