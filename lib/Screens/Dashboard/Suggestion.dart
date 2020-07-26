import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/Services/database.dart';

class Suggestion extends StatefulWidget {
  @override
  _SuggestionState createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  FirebaseAuth auth=FirebaseAuth.instance;
  String uid1;
  void uidOfUser() async {
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
    // here you write the codes to input the data into firestore
  }

  @override
  void initState() {
    // TODO: implement initState
    uidOfUser();
  }
  String suggestion;
  DatabaseService db=new DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50,
        title: Text("Write Suggestion",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),
      body:Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Text("Write us your valuable Suggestion... ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
            SizedBox(height: 30,),
            SizedBox(height: 5,),
            TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return 'Please provide a suggestion';
                }
                return null;
              },
              onChanged: (val){
                suggestion=val;
              },
            ),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                onPressed: () async{


                  uidOfUser();
                  print("JJJ"+uid1);
                  var result=await db.addSuggestion(suggestion, uid1);


                    Fluttertoast.showToast(
                        msg: "Thank you for your suggestion.. It means a lot to us :)",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 18.0);

                },
                elevation: 5,
                child: Text("Send it!!!!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
