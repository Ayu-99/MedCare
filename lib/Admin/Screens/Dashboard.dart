import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medcare/Admin/Screens/AddNewCategory.dart';
import 'package:medcare/Admin/Screens/AddNewMedicine.dart';
import 'package:medcare/Admin/Screens/in-store-orders.dart';
import 'package:medcare/Admin/Screens/out-stock-orders.dart';


class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  @override

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 50,
        title: Text("Welcome Admin",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),
      body: Center(

        child: Column(
          children: [
            Card(
              margin: EdgeInsets.fromLTRB(30, 90,30,30),
              elevation: 10.0,
              child: Column(

                children: [
                  ListTile(
                    leading: Icon(Icons.add),
                    onTap: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return AddNewCategory();
                      }));
                    },
                    title:Text(
                      "Add New Category",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    )
                  ),
                ],

              ),

            ),
            SizedBox(height: 10,),
            Card(
              margin: EdgeInsets.all(30),
              elevation: 10.0,
              child: Column(

                children: [
                  ListTile(
                      leading: Icon(Icons.shopping_cart),
                      onTap: (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AddNewMedicine();
                        }));
                      },
                      title:Text(
                        "Add New Medicine",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                ],

              ),

            ),
            SizedBox(height: 10,),
            Card(
              margin: EdgeInsets.all(30),
              elevation: 10.0,
              child: Column(

                children: [
                  ListTile(

                      leading: Icon(Icons.list),
                      onTap: (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return OutOfStockOrders();
                        }));
                      },
                      title:Text(
                        "View all Out-Stock Orders",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                ],

              ),

            ),
            SizedBox(height: 10,),
            Card(
              margin: EdgeInsets.all(30),
              elevation: 10.0,
              child: Column(

                children: [
                  ListTile(

                      leading: Icon(Icons.format_list_bulleted),
                      onTap: (){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return InStoreOrders();
                        }));
                        },
                      title:Text(
                        "View all In-stock Orders",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      )


                  ),
                ],

              ),


            ),
          ],

        ),

      ),
    );


  }
}
