import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/Services/database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';

class BuyDetails extends StatefulWidget {

  String name,price,category,imageUrl,uidOfMedicine,userUid;
  BuyDetails(String userUid,uid,name,price,imageUrl,category){
    this.uidOfMedicine=uid;
    this.userUid=userUid;
    this.name=name;
    this.price=price;
    this.imageUrl=imageUrl;
    this.category=category;

  }
  @override
  _BuyDetailsState createState() => _BuyDetailsState();
}

class _BuyDetailsState extends State<BuyDetails> {
  final _formKey = GlobalKey<FormState>();

  var quantites=["3 tablets", "6 tablets", "10 tablets", "15 tablets","20 tablets",
    "1 bottle"];
  var currentQuantitySelected="3 tablets";
  var multiplier=["1","2","3","4","5","6","7","8","9","10"];
  var currentMultiplierSelected="1";
  String typeSelected="";
  FirebaseAuth auth=FirebaseAuth.instance;
  String uid1;
  int amount=0;

  Razorpay _razorpay;

  void uidOfUser() async {
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
    // here you write the codes to input the data into firestore
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

  DatabaseService db=new DatabaseService();


  @override
  void initState() {
    // TODO: implement initState

    uidOfUser();
    _razorpay=Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async{
    var options={
      'key':'rzp_test_uvmilFv72Adj37',
      'amount':amount*100,
      'name':'MedCare',
      'desciption':'Test Payment',
      'prefill':{'contact':'','email':''},
      'external':{
        'wallets':['paytm']
      }
    };

    try{

      _razorpay.open(options);

    }catch(e){
      print(e.toString());
    }

  }

  void _handlePaymentSuccess(PaymentSuccessResponse response){

    Fluttertoast.showToast(
        msg: "Payment Success: " + response.paymentId,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 20.0
    );

  }

  void _handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(
        msg: "Error occured.."+response.code.toString()+ " "+ response.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent[100],
        textColor: Colors.white,
        fontSize: 20.0
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(
        msg: "External Wallet: "+response.walletName,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 20.0
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 50,
          title: Text("Buy Medicine",style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),),
        ),


        body:Form(
      key: _formKey,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Image.network(widget.imageUrl,height: 200,width: 200,),
              SizedBox(height: 5.0,),
              Text("Name: "+widget.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),),
              SizedBox(height: 5,),

              Text("Price(per tablet/bottle):  ₹"+widget.price,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
              SizedBox(height: 5,),

              Text("Category: "+widget.category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),

              SizedBox(height: 20,),
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

              SizedBox(height: 20,),
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
              Text("Your total bill is: ₹"+(int.parse(totalQuantity())*int.parse(widget.price)).toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),

              SizedBox(height: 20,),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: RaisedButton(
                  onPressed: (){

                    amount=int.parse(totalQuantity())*int.parse(widget.price);
                    print(uid1);
                    print(widget.uidOfMedicine);
                    if(uid1!=null){

                      var result=db.addToStoreOrders(uid1, widget.uidOfMedicine,widget.name,
                          (int.parse(totalQuantity())*int.parse(widget.price)).toString(),
                          currentQuantitySelected, currentMultiplierSelected, widget.category,widget.imageUrl);
                        if(result!=null){
//                          print("result"+result.toString());
//                          print("Done");
                        openCheckout();

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
                    }else{
                      print("try");
                    }

//                    var result=db.addToStoreOrders("R7qVd7Ijv5efhqvUoSSmAzbdZ6l2",
//                        "1QrlmAgVLwuKiA2ruujN","Dolo",
//                        "50",
//                        "2", "3", "Fever","https://firebasestorage.googleapis.com/v0/b/medcare-be98b.appspot.com/o/medicines%2Fdolo.jpg?alt=media&token=66f06e5b-58c4-4fd3-a6da-d3544e5863b6");



                  },
                  elevation: 5,
                  child: Text("Make Payment",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}


