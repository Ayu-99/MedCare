
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference categoryCollection=Firestore.instance.collection('category');
  final CollectionReference usersCollection =Firestore.instance.collection('users');

  final CollectionReference suggestionsCollection =Firestore.instance.collection('suggestions');


  Future updateUserData(String email) async{

    return await usersCollection.document(uid).setData(
      {
        'email':email,
        'med_uid':uid,
      }
    );

  }

  //get category stream
  Stream<QuerySnapshot> get Categories{
      return categoryCollection.snapshots();
  }
//
//  Future returnEmail() async{
//    return await usersCollection.where(uid, isEqualTo: uid).getDocuments();
//  }

  Future addToCart(String uidOfUser, String uidOfMedicine, String name, String price, String imageUrl, String category) async{

    try{

      return await usersCollection.document(uidOfUser).collection('cart').document(uidOfMedicine).setData(
          {
            'med_uid':uidOfMedicine,
            'name':name,
            'price':price,
            'imageUrl':imageUrl,
            'category':category
          }
      );
    }catch(e){
      return null;
    }


  }

  Future addToOutOfStoreOrders(String uidOfUser,  String name, String suffer, String quantity, String multiplier) async{

    print("uid in database"+uidOfUser);
    try{

      return await usersCollection.document(uidOfUser).collection('out-of-store-orders').document().setData({

        'name':name,
        'suffering':suffer,
        'quantity':quantity,
        'multiplier':multiplier,
        'status':'ACTIVE',
        'bill': 'YET TO BE CONVEYED'
      });

    }catch(e){
      return null;
    }


  }

  Future addToStoreOrders(String uidOfUser, String uidOfMedicine, String name, String bill, String quantity, String multiplier,String category,String imageUrl) async{

//    print("uid in database"+uidOfUser);
    try{

      return await usersCollection.document(uidOfUser).collection('in-store-orders').document(uidOfMedicine).setData({

        'name':name,
        'imageUrl':imageUrl,
        'bill':bill,
        'quantity':quantity,
        'multiplier':multiplier,
        'category':category,
        'status':'ACTIVE',
      });

    }catch(e){
      return null;
    }


  }

  Future addSuggestion(String sugg, String uid) async{
    print("KKK"+uid);

    try{
      return await suggestionsCollection.document().setData(
          {
            'suggestion':sugg,
            'useruid':uid,
          }
      );
    }catch(e){
      print(e.toString());
      return null;
    }


  }

  FirebaseAuth auth=FirebaseAuth.instance;
  String uid1;
  void uidOfUser() async {
    final FirebaseUser user = await auth.currentUser();
    uid1 = user.uid.toString();
    // here you write the codes to input the data into firestore
  }
  Future getEmail () async{
    uidOfUser();
    await usersCollection.where(uid,isEqualTo: uid1).getDocuments();

  }


  Future removeFromCart(String uid, String itemUid) async{
    try{

      return await usersCollection.document(uid).collection("cart").document(itemUid).delete();


    }catch(e){
      print(e.toString());
      return null;
    }
  }


}
