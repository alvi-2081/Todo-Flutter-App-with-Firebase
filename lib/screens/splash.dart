import 'dart:async';
import 'package:firebase/screens/signup.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  // void initState() {
  //   super.initState();
  //   Timer(
  //       Duration(seconds: 5),
  //       () => Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => Signup())));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.indigo[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 430,
              child: Image.asset(
                "assets/logo2.png",
                height: 430,
                width: 300,
                // fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Signup())),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Merriweather',
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 20, horizontal: 38)),
                elevation: MaterialStateProperty.all(10),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side:
                            BorderSide(color: Color.fromRGBO(57, 73, 171, 1)))),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(57, 73, 171, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
