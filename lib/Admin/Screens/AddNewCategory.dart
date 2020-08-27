import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medcare/Services/database.dart';
import 'package:path/path.dart';
import 'dart:async';

class AddNewCategory extends StatefulWidget {
  @override
  _AddNewCategoryState createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String fileName;
  var _image;
  DatabaseService db=new DatabaseService();
  var url,ref;

  Future getImage() async{

    var image=await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image=image;
    });

  }

  void tasks() async{
    ref = FirebaseStorage.instance.ref().child(fileName);
    url = await ref.getDownloadURL();
    print(url);

  }
  Future uploadPicture() async{

    fileName=basename(_image.path);
    StorageReference fs= await FirebaseStorage.instance.ref().child(fileName);
    print("xx"+fileName);
    print(_image);


    StorageUploadTask uploadTask=fs.putFile(_image);
    await uploadTask.onComplete.then((value) => tasks());

  }

  @override
  void initState() {
    // TODO: implement initState
    name="";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 50,
        title: Text("Add New Category",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),),
      ),
      body: Center(
      child:Container(
        margin: EdgeInsets.all(20),
        child: Column(

          children: [

            Form(
              key:_formKey,
              child: Column(
                children: [

                  SizedBox(height: 50,),
                  Text("Enter name of Category:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                  ),),
                  SizedBox(height: 10,),

                  TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'Please write name of category!!';
                      }
                      return null;
                    },
                    onChanged: (value){
                      name=value;
                    },
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        RaisedButton(

                          onPressed: ()async{
                            await getImage();
                            if(_image!=null){
                              Fluttertoast.showToast(
                                  msg: "Image Added",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 24.0);
                            }else{
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

                        SizedBox(width: 8,),

                        _image!=null?Icon(Icons.check,
                          size: 25.0,
                        ):SizedBox(width: 5,),
//
                      ],
                    ),
                  ),



                  SizedBox(height:50),
                  RaisedButton(
                    onPressed: ()  async{
                      if(_formKey.currentState.validate()){

                        await uploadPicture();
                        name=name[0].toUpperCase() + name.substring(1);
                        if(db.addNewCategory(name,url)!=null){
                          Fluttertoast.showToast(
                              msg: "Category Added",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 24.0);
                        }else{
                          Fluttertoast.showToast(
                              msg: "Category Not Added",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 24.0);
                        }

                      }else{
                        Fluttertoast.showToast(
                            msg: "Category Not added",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 24.0);
                            name="";
                      }
                    },
                    child: Text("ADD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),),
                  ),
                ],

              ),
            ),

          ],
        ),
      ),

      )
    );
  }
}

