import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medcare/Services/database.dart';
import 'package:medcare/loading.dart';

class InStoreOrders extends StatefulWidget {
  @override
  _InStoreOrdersState createState() => _InStoreOrdersState();
}

class _InStoreOrdersState extends State<InStoreOrders> {

  DatabaseService db=new DatabaseService();
//  Future getInStoreOrders() async{
//
//    var firestore=Firestore.instance;
//    QuerySnapshot qn=await firestore.collection("users").document(uid1).collection("in-store-orders").getDocuments();
//    return qn.documents;
//
//  }

  @override
  void initState() {
    // TODO: implement initState
    db.getAllInStockOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50,
        title: Text(
          "All In-Stock-Orders",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: FutureBuilder(
        future:db.getAllInStockOrders(),
        builder: (context,snapshot){

          if(snapshot.data==null ||snapshot.connectionState==ConnectionState.waiting){
            print("data length"+snapshot.data.toString());
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
                                  Image.network(snapshot.data[index].data['imageUrl'],
                                    width: 75,
                                    height: 100,),

                                  SizedBox(width: 10,),
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

                                      Text("Category:-  "+snapshot.data[index].data['category'],
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black
                                        ),),
                                      SizedBox(height: 10,),

                                      Text("Total Bill:-  ₹"+snapshot.data[index].data['bill'],
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
                                          SizedBox(height: 5.0,),




                                        ],

                                      ),
                                      SizedBox(height: 5.0,),
                                      Text("UID:-  "+snapshot.data[index].data['uid'],
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black
                                        ),),
                                      SizedBox(height: 10,),

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
