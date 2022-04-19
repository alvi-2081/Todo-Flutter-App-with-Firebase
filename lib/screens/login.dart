import 'package:firebase/controllers/authentication.dart';
import 'package:firebase/screens/home.dart';
import 'package:firebase/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  late String email;
  late String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void handleLogin() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      logIn(email, password, context).then((value) {
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
      return "Required";
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
        //                APP BAR
        //
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigo[600],
          title: Text(
            "Login",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather',
            ),
          ),
        ),
        //
        //                  APP BODY
        //
        body: Form(
          key: formkey,
          child: Center(
              child: SingleChildScrollView(
            child: Column(
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
                //            EMAIL TEXT FIELD
                //
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 35),
                  child: TextFormField(
                    onChanged: (val) {
                      email = val;
                    },
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
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Required *"),
                      EmailValidator(errorText: "Not A Valid Email"),
                    ]),
                  ),
                ),
                //
                //            PASSWORD TEXT FIELD
                //
                Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 35),
                  child: TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      password = val;
                    },
                    validator: validatePass,
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
                  height: 5,
                ),
                //
                //            FORGOT AND LOGIN BUTTON
                //
                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              //forgot password screen
                            },
                            child: Text(
                              'Forget Password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                                color: Colors.indigo[600],
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: handleLogin,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Merriweather',
                                ),
                              ),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 33)),
                                elevation: MaterialStateProperty.all(8),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: Color.fromRGBO(
                                                57, 73, 171, 1)))),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(57, 73, 171, 1)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //
                    //        GOOGLE SIGNUP
                    //
                    InkWell(
                      onTap: () => googleSignin().whenComplete(() async {
                        User user = await FirebaseAuth.instance.currentUser!;
                        Get.off(Home(uid: user.uid));
                      }),
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.5,
                                color: Color.fromRGBO(57, 73, 171, 1))),
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
                    //          NAVIGATE TO SIGNUP
                    //
                    InkWell(
                      onTap: () {
                        // send to signin screen
                        Get.off(Signup());
                      },
                      child: Text(
                        "Don't Have Account SignUp Here",
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
                ))
              ],
            ),
          )),
        ));
  }
}
