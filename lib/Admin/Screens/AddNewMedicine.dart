import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medcare/Services/database.dart';
import 'package:path/path.dart';
import 'dart:async';

class AddNewMedicine extends StatefulWidget {
  @override
  _AddNewMedicineState createState() => _AddNewMedicineState();
}

class _AddNewMedicineState extends State<AddNewMedicine> {
  final _formKey = GlobalKey<FormState>();
  String name, price, category="Fever";
  String fileName;
  var _image;
  var c=[];
  List<String> categories=new List<String>();
  DatabaseService db = new DatabaseService();
  var url, ref;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void tasks() async {
    ref = FirebaseStorage.instance.ref().child("/medicines/"+fileName);
    url = await ref.getDownloadURL();
    print(url);
  }

  Future uploadPicture() async {
    fileName = basename(_image.path);
    StorageReference fs = await FirebaseStorage.instance.ref().child("/medicines/"+fileName);
    print("xx" + fileName);
    print(_image);

    StorageUploadTask uploadTask = fs.putFile(_image);
    await uploadTask.onComplete.then((value) => tasks());
  }


  Future getAllCategories() async{
    await db.getAllCategories().then((QuerySnapshot docs){
      if(docs.documents.isNotEmpty){
        docs.documents.asMap().forEach((key, value) {
          if(docs.documents[key]["name"]!=null){

            print(docs.documents[key]["name"].toString());
//            c.insert(key, docs.documents[key]["name"].toString());
            categories.add(docs.documents[key]["name"].toString());
          }
        });
      }
    });

    setState(() {

    });
  }

  @override
  void initState(){
    // TODO: implement initState
    name = "";
    price = "";
    getAllCategories();
    print(categories);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 50,
          title: Text(
            "Add New Medicine",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        body: 
        SingleChildScrollView(
          child: Center(
            child: Container(
              margin:
                  EdgeInsets.only(left: 50, top: 2.0, right: 50, bottom: 10.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Enter name of Medicine:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please write name of category!!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Enter price of Medicine:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please write price of category!!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            price = value;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Choose category of Medicine:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        DropdownButton<String>(
                          value: category,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              category = newValue;
                            });
                          },
                          items: categories.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  await getImage();
                                  if (_image != null) {
                                    Fluttertoast.showToast(
                                        msg: "Image Added",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 24.0);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Image Not Added",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 24.0);
                                  }
                                },
                                child: Text("Add an image"),
                              ),

                              SizedBox(
                                width: 8,
                              ),

                              _image != null
                                  ? Icon(
                                      Icons.check,
                                      size: 25.0,
                                    )
                                  : SizedBox(
                                      width: 5,
                                    ),
//
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              await uploadPicture();
                              name=name[0].toUpperCase() + name.substring(1);
                              category=category[0].toUpperCase() + category.substring(1);
                              if(db.addNewMedicine(name,url,price,category)!=null){
                                Fluttertoast.showToast(
                                    msg: "Medicine Added",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 24.0);
                                name="";
                                category="";
                                price="";
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Medicine Not Added",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 24.0);
                              }
                            }else{
                              Fluttertoast.showToast(
                                  msg: "Medicine Not added",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 24.0);
                            }
                          },
                          child: Text(
                            "ADD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
