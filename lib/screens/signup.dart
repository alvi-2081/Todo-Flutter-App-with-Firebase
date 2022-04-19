import 'package:firebase/controllers/authentication.dart';
import 'package:firebase/screens/home.dart';
import 'package:firebase/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  // late String username;
  late String email;
  late String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void handleSignup() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      signUp(email.trim(), password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(uid: value.uid),
              ));
        }
      });
    }
  }

  String? validatePass(value) {
    if (value!.isEmpty) {
      return "Required *";
    } else if (value.length < 6) {
      return "Password Should be Atleast 6 Character";
    } else if (value.length > 15) {
      return "Password Should Not bemor than 15 Character";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //
      //                      APP BAR
      //
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo[600],
        title: Text(
          "SignUp",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Merriweather',
          ),
        ),
      ),
      //
      //                      APP BODY
      //
      body: Form(
        key: formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: Image.asset(
                "assets/logo2.png",
                height: 200,
                width: 200,
              ),
            ),
            //
            //                 EMAIL TEXT FIELD
            //
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 35),
              child: TextFormField(
                onChanged: (val) {
                  email = val;
                },
                validator: MultiValidator([
                  RequiredValidator(errorText: "Required *"),
                  EmailValidator(errorText: "Not A Valid Email"),
                ]),
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  // labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.indigo[600],
                  ),
                  filled: true,
                  fillColor: Colors.indigo[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            //
            //                PASSWORD TEXT FIELD
            //
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 35),
              child: TextFormField(
                onChanged: (val) {
                  password = val;
                },
                validator: validatePass,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  // labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.indigo[600],
                  ),
                  filled: true,
                  fillColor: Colors.indigo[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            //
            //                SIGNUP BUTTON
            //
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 36),
              // height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: handleSignup,
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15, horizontal: 33)),
                      elevation: MaterialStateProperty.all(8),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: Color.fromRGBO(57, 73, 171, 1)))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(57, 73, 171, 1)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            //
            //                  GOOGLE SIGNUP
            //
            InkWell(
              onTap: () => googleSignin().whenComplete(() async {
                User user = await FirebaseAuth.instance.currentUser!;
                Get.off(Home(uid: user.uid));
              }),
              child: Container(
                width: 200,
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.5, color: Color.fromRGBO(57, 73, 171, 1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/google.png", height: 36),
                    Text(
                      'Sign in With Google',
                      style: TextStyle(
                          fontSize: 15.5,
                          color: Colors.indigo[600],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            //
            //                  NAVIGATE TO SIGNUP
            //
            InkWell(
              onTap: () {
                // send to signin screen
                Get.off(Login());
              },
              child: Text(
                "Already Have Account LoginIn Here",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                  color: Colors.indigo[600],
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Merriweather',
                ),
              ),
            ),
          ],
        ))),
      ),
    );
  }
}
