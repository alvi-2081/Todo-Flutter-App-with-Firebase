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
      appBar: AppBar(
        backgroundColor: Colors.indigo[600],
        title: Text('   SignUp'),
      ),
      body: Form(
        key: formkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Todo App',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 35),
                    )),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                  child: TextFormField(
                    onChanged: (val) {
                      email = val;
                    },
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Required *"),
                      EmailValidator(errorText: "Not A Valid Email"),
                    ]),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
                  child: TextFormField(
                    onChanged: (val) {
                      password = val;
                    },
                    validator: validatePass,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                            child: Text('SignUp'),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              // side: BorderSide(color: Colors.red)
                            ))),
                            onPressed: handleSignup
                            //  =>
                            // signUp(email.trim(), password)
                            //         .whenComplete(() async {
                            //       User user = await FirebaseAuth
                            //           .instance.currentUser!;
                            //       Get.offAll(Home(uid: user.uid));
                            //     }
                            // )
                            )),
                    SizedBox(
                      height: 10.0,
                    ),
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => googleSignin().whenComplete(() async {
                        User user = await FirebaseAuth.instance.currentUser!;
                        Get.off(Home(uid: user.uid));
                      }),
                      child: Image(
                        image: AssetImage('assets/signin.png'),
                        width: 200.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        // send to login screen
                        Get.off(Login());
                      },
                      child: Text(
                        "Already Have Account LoginIn Here",
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
