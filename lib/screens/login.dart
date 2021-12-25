import 'package:firebase/controllers/authentication.dart';
import 'package:firebase/screens/home.dart';
import 'package:firebase/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

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
        appBar: AppBar(
          title: Text('   Login'),
        ),
        body: Form(
          key: formkey,
          child: Center(
              child: SingleChildScrollView(
            child: Column(
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
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
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
                  padding: EdgeInsets.fromLTRB(18, 10, 18, 0),
                  child: TextFormField(
                    obscureText: true,
                    onChanged: (val) {
                      password = val;
                    },
                    validator: validatePass,
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
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        //forgot password screen
                      },
                      child: Text('Forgot Password'),
                    ),
                    Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                            child: Text('Login'),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.indigo[600]),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  // side: BorderSide(color: Colors.red)
                                ))),
                            onPressed: handleLogin
                            // () => logIn(email.trim(), password)
                            //         .whenComplete(() async {
                            //       // User user =
                            //       //     await FirebaseAuth.instance.currentUser!;
                            //       Get.off(Home(uid: value.uid));
                            //     })
                            )),
                    SizedBox(
                      height: 13.0,
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
                      height: 13.0,
                    ),
                    InkWell(
                      onTap: () {
                        // send to signin screen
                        Get.off(Signup());
                      },
                      child: Text(
                        "Don't Have Account SignUp Here",
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
