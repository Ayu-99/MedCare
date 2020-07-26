import 'package:flutter/material.dart';


class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 50,
        title: Text("About-MedCare",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),

      body: Center(
        child: Container(
          child: Column(



            children: [

              Image.asset("assets/images/logo.png",width: 200,height: 200,),
            SizedBox(height:30),

              Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(

                  child: Row(
                    children: [


                      SizedBox(width: 85.0,),

                      Text("MedCare",
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w600,
                        ),),


                    ],

                  ),



                ),

              ),
              SizedBox(height: 5.0,),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("An e-commerce app designed for providing medicines at your door step !!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),),
                    SizedBox(height: 250.0,),
                    Text("For further queries- Contact-99999 88888",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),),
                  ],
                )

              ),


            ],
          ),
        ),
      ),

    );
  }
}
