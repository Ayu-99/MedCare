import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/Screens/Dashboard/home.dart';
import 'package:medcare/Services/database.dart';

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50,
        title: Text("Place your order",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),

      body: MyForm(),

    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  String name,suffering;
  var quantites=["3 tablets", "6 tablets", "10 tablets", "15 tablets","20 tablets",
  "1 bottle"];
  var currentQuantitySelected="3 tablets";
  var multiplier=["1","2","3","4","5","6","7","8","9","10"];
  var currentMultiplierSelected="1";
  String typeSelected="";
  DatabaseService db=new DatabaseService();
  FirebaseAuth auth=FirebaseAuth.instance;
  String uid1;
  void uidOfUser() async {
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    uidOfUser();
  }

  String totalQuantity(){



    if(currentQuantitySelected[1]!=" "){

      if(currentQuantitySelected[3]=="b"){
        typeSelected="bottles";
      }else{
        typeSelected="tablets";
      }

        return (int.parse(currentQuantitySelected.substring(0,2))*int.parse(currentMultiplierSelected)).toString();
      }

    if(currentQuantitySelected[2]=="b"){

      typeSelected="bottles";
    }else{
      typeSelected="tablets";
    }

    if(currentQuantitySelected[0]=='1' && currentMultiplierSelected=='1'){
      if(currentQuantitySelected[2]=="b"){

        typeSelected="bottle";
      }else{
        typeSelected="tablet";
      }
    }
    return (int.parse(currentQuantitySelected[0])*int.parse(currentMultiplierSelected)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 5.0,),
            Text("Enter the name of the medicine:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),),
            SizedBox(height: 5,),
            TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return 'Please enter the name of the medicine';
                }
                return null;
              },
              onChanged: (val){
                name=val;
              },
            ),
            SizedBox(height: 10,),
            Text("Please, tell the suffering!!",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
            TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return 'Please enter the suffering';
                }
                return null;
              },
              onChanged: (val){
                suffering=val;
              },
            ),
            SizedBox(height: 10,),
            Text("Choose the quantity of medicine",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
            SizedBox(height: 5,),
            DropdownButton<String>(
              elevation: 50,
              items: quantites.map((String dropDownStringItem)  {
                return DropdownMenuItem<String>(
                  value:dropDownStringItem,
                  child:Text(dropDownStringItem),
                );
              }).toList(),

              onChanged: (String quantitySelected){
                setState(() {
                  this.currentQuantitySelected=quantitySelected;
                });

              },
              value: currentQuantitySelected,
            ),

            SizedBox(height: 10,),
            Text("Choose the Multiplier",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
            SizedBox(height: 5,),
            DropdownButton<String>(
              items: multiplier.map((String dropDownStringItem)  {
                return DropdownMenuItem<String>(
                  value:dropDownStringItem,
                  child:Text(dropDownStringItem),
                );
              }).toList(),

              onChanged: (String MultiplierSelected){
                setState(() {
                  this.currentMultiplierSelected=MultiplierSelected;
                });

              },
              value: currentMultiplierSelected,
            ),

            SizedBox(height: 5,),
            Text("Your total quantity is: "+totalQuantity() + " "+typeSelected,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),),
            SizedBox(height: 10,),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                onPressed: (){


                  print("uid1 in place order"+uid1);
                  if(_formKey.currentState.validate()!=null) {


                    var result=db.addToOutOfStoreOrders(uid1, name, suffering, currentQuantitySelected, currentMultiplierSelected);
                    if(result!=null){

                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Order Processed.. You will be informed about the payment shortly!!!")));

//                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                        return Home("");
//                      }));
                    }else{
                      Fluttertoast.showToast(
                          msg: "Error occured.. Try Again!!",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.redAccent[100],
                          textColor: Colors.white,
                          fontSize: 12.0
                      );
                    }


                  }
                },
                elevation: 5,
                child: Text("Place your order",
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

