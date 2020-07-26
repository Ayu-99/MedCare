import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medcare/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutStoreOrders extends StatefulWidget {


  @override
  _OutStoreOrdersState createState() => _OutStoreOrdersState();
}

class _OutStoreOrdersState extends State<OutStoreOrders> {

  FirebaseAuth auth=FirebaseAuth.instance;
  String uid1;
  Future<String> uidOfUser() async {

    print(uid1);
    return uid1;
  }

  Future getOutStoreOrders() async{

    var firestore=Firestore.instance;
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
    QuerySnapshot qn=await firestore.collection("users").document(uid1).collection("out-of-store-orders").getDocuments();
    return qn.documents;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50,
        title: Text("My out-Store orders",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),
      body:FutureBuilder(
        future:getOutStoreOrders(),
        builder: (context,snapshot){


          if(snapshot.data==null ||snapshot.connectionState==ConnectionState.waiting){
            return Loading();
          }else{

            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  return Card(

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

                                  SizedBox(width: 50,),
                                  Column(
                                    children: [

                                      Text("NAME:  "+snapshot.data[index].data['name'],
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black
                                        ),),
                                      SizedBox(height: 10,),

                                      Text("Quantity:  "+snapshot.data[index].data['quantity'],
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black
                                        ),),
                                      SizedBox(height: 10,),

                                      Text("Multiplier:  "+snapshot.data[index].data['multiplier'],
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black
                                        ),),
                                      SizedBox(height: 10,),
                                      Text("Category:-  "+snapshot.data[index].data['suffering'],
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black
                                        ),),
                                      SizedBox(height: 10,),


                                      Text(snapshot.data[index].data['bill']=="YET TO BE CONVEYED"?" Total Bill:- YET TO BE CONVEYED":"Total Bill:-  ₹"+snapshot.data[index].data['bill'],
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black
                                        ),),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text("Status:- ",
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),),
                                          SizedBox(width: 5.0,),
                                          Text(snapshot.data[index].data['status'],
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                              color: snapshot.data[index].data['status']=='ACTIVE'?Colors.redAccent:Colors.green,
                                            ),),
                                        ],
                                      ),

                                      SizedBox(height: 10,),


                                    ],
                                  )

                                ],
                              ),
                            ],
                          ),

                        ),

                        SizedBox(height: 10,),
                      ],
                    ),

                  );
                });
          }
        },
      ),

    );
  }
}
