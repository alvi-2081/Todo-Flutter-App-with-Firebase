import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final google_SignIn = GoogleSignIn();
//
//                    GOOGLE SIGN IN
//
Future<bool> googleSignin() async {
  GoogleSignInAccount? googleSignInAccount = await google_SignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);
    User? user = await auth.currentUser;
    // return Future.value(true);
  }
  return Future.value(true);
}

//
//                       USER SIGNUP
//
Future<User> signUp(String email, String password, BuildContext context) async {
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    // FirebaseFirestore.instance.collection('users').add({
    //   "username": username,
    //   "email": email,
    // });
    return Future.value(user);
  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.BOTTOM);
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    return Future.value();
  }
}

//
//                      USER LOGIN
//
Future<User> logIn(String email, String password, BuildContext context) async {
  try {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return Future.value(user);
  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.BOTTOM);
    // if (e.code == 'user-not-found') {
    //   print('No user found for that email.');
    // } else if (e.code == 'wrong-password') {
    //   print('Wrong password provided for that user.');
    // }
    return Future.value(null);
  }
}

//
//                          GOOGLE AND USER LOGOUT
//
Future<bool> signOutUser() async {
  // User? user = await auth.currentUser;
  // if (user!.providerData[1].providerId == 'google.com') {
  //   await google_SignIn.disconnect();
  //   await GoogleSignIn().signOut();
  // }
  await GoogleSignIn().signOut();
  await auth.signOut();
  return Future.value(true);
}
