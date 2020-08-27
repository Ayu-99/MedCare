import 'package:firebase_auth/firebase_auth.dart';
import 'package:medcare/Services/database.dart';
import 'package:medcare/models/user.dart';

class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;


  //create user object based on firebase user
  User _userFromFirebase(FirebaseUser user){
    return user!=null ? User(uid:user.uid):null;
  }

  //auth change user stream
  Stream<User> get user{
    //when sign in-returns firebase user
    //when logout-returns null
    return _auth.onAuthStateChanged
    .map((FirebaseUser user) => _userFromFirebase(user));
  }


  //signIn anon
  Future signInAnon() async{
    try{

      AuthResult authResult=await _auth.signInAnonymously();
      FirebaseUser user=authResult.user;
      return _userFromFirebase(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future<User> signInWithEmailAndPassword(String email,String password) async{
    try{

      AuthResult authResult=await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=authResult.user;
      print(user.isEmailVerified);
      if(user.isEmailVerified==true){
        return _userFromFirebase(user);

      }
      return null;



    }catch(e){
      print(e.toString());
//      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email,String password) async{

    try{

      AuthResult authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user=authResult.user;
      await user.sendEmailVerification();
      await DatabaseService(uid:user.uid).updateUserData(email);
      return _userFromFirebase(user);

    }catch(e){
      print(e.toString());
      return null;
    }

  }


  //sign out

  Future signOut() async{
    try{
      return await _auth.signOut();

    }catch(e){
      print("Sign out error:"+e.toString());
      return null;
    }
  }




}