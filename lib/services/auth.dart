import 'package:chatappa/helpers/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../modal.dart';


class AuthMethods{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Stream<FirebaseUser> get user => _firebaseAuth.onAuthStateChanged;

  User _userromFireBaseUser(FirebaseUser user){
    return user != null?  User(userID: user.uid) : null ;
  }


  Future<void> SignInwithEmailAndPasswrord(String email,String password) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
       print("SignIn");

    } on PlatformException catch (error) {
      throw (error.toString());
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
        usersRef.document(authResult.user.uid).setData({
          'name': name,
          'email': email,
          'profileImageUrl': '',
          'bio': '',
          'token': "token",
        });
      }
    } on PlatformException catch (error) {
      throw (error);
    }
  }


  Future<void> Signout() {
    Future.wait([_firebaseAuth.signOut()]);
  }
}



