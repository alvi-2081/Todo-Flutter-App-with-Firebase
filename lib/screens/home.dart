import 'package:firebase/controllers/authentication.dart';
import 'package:firebase/screens/add.dart';
import 'package:firebase/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  final String uid;
  const Home({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(uid);
}

class _HomeState extends State<Home> {
  final String uid;
  _HomeState(this.uid);
  var taskcollections = FirebaseFirestore.instance.collection('users');
  late String task;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController taskTitleEditController = TextEditingController();
  TextEditingController taskDetailEditController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //
        //                            APPBAR STARTS
        //
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigo[600],
          title: Text(
            "My Tasks",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Merriweather',
            ),
          ),
        ),
        //
        //                            DRAWER STARTS
        //
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountEmail: Text("abdullah@gmail.com"),
                accountName: Text("abdullah"),
              ),
              SizedBox(
                height: 8,
              ),
              ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.indigo[600],
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      color: Colors.indigo[600],
                    ),
                  ),
                  onTap: () => signOutUser().whenComplete(() async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false);
                      })),
              SizedBox(
                height: 8,
              ),
              ListTile(
                  leading: Icon(Icons.info, color: Colors.indigo[600]),
                  title: Text(
                    "About",
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      color: Colors.indigo[600],
                    ),
                  ),
                  onTap: () {})
            ],
          ),
        ),
        //
        //                            FLOATING ACTIONS BUTTON STARTS
        //
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.indigo[600],
            onPressed: () {
              Get.to(Add(), arguments: uid);
            }),
        //
        //                            BODY STARTS
        //
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: taskcollections.doc(uid).collection("task").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        elevation: 5,
                        color: Colors.indigo[100],
                        child: Slidable(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color.fromRGBO(57, 73, 171, 1),
                                    width: 1,
                                  )),
                              width: MediaQuery.of(context).size.width * 1,
                              height: 100,
                              child: Stack(
                                children: [
                                  Positioned(
                                      left: 15,
                                      top: 18,
                                      child: Text(
                                        data['taskName'],
                                        style: TextStyle(
                                            fontFamily: 'Merriweather',
                                            // fontStyle: FontStyle.,
                                            color: Colors.indigo[600],
                                            fontWeight: FontWeight.w900,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 23),
                                      )),
                                  Positioned(
                                      left: 15,
                                      bottom: 20,
                                      child: Text(
                                        data['taskDetail'],
                                        style: TextStyle(
                                            fontFamily: 'Merriweather',
                                            color: Colors.indigo[400],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )),
                                  Positioned(
                                      right: 55,
                                      top: 25,
                                      child: Text(
                                        data['taskDate'],
                                        style: TextStyle(
                                            color: Colors.indigo[400],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )),
                                  Positioned(
                                      right: 55,
                                      bottom: 25,
                                      child: Text(
                                        data['taskTime'],
                                        style: TextStyle(
                                            color: Colors.indigo[400],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )),
                                  Positioned(
                                      right: 10,
                                      top: 6,
                                      child: IconButton(
                                          color: Colors.indigo[600],
                                          onPressed: () {
                                            updateDialog(document);
                                          },
                                          icon: Icon(Icons.edit))),
                                  Positioned(
                                      right: 10,
                                      bottom: 10,
                                      child: IconButton(
                                          color: Colors.indigo[600],
                                          onPressed: () {
                                            document.reference.delete();
                                          },
                                          icon: Icon(Icons.delete)))
                                ],
                              )),
                        ),
                      );
                    }).toList(),
                  );
                },
              )),
            ],
          ),
        ));
  }

  updateDialog(DocumentSnapshot<Object?> document) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Update Task",
              style: TextStyle(
                  fontSize: 25,
                  decoration: TextDecoration.underline,
                  fontFamily: 'Merriweather',
                  color: Color.fromRGBO(63, 81, 181, 1),
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(children: [
                TextField(
                  controller: taskTitleEditController,
                  style: TextStyle(color: Colors.indigo[600]),
                  cursorColor: Colors.indigo[600],
                  decoration: InputDecoration(
                      enabledBorder: new UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(63, 81, 181, 1)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(63, 81, 181, 1)),
                      ),
                      labelText: 'Task Title',
                      hintText: 'Enter Task Title',
                      labelStyle: TextStyle(
                          fontFamily: 'Merriweather',
                          color: Color.fromRGBO(63, 81, 181, 1),
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: taskDetailEditController,
                  style: TextStyle(color: Colors.indigo[600]),
                  cursorColor: Colors.indigo[600],
                  decoration: InputDecoration(
                      enabledBorder: new UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(63, 81, 181, 1)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(63, 81, 181, 1)),
                      ),
                      labelText: 'Task Details',
                      hintText: 'Enter Task Details',
                      labelStyle: TextStyle(
                          fontFamily: 'Merriweather',
                          color: Color.fromRGBO(63, 81, 181, 1),
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                ListTile(
                  onTap: () {
                    _selectDate(context);
                  },
                  title: const Text(
                    'Select a Date',
                    style: TextStyle(
                        fontFamily: 'Merriweather',
                        color: Color.fromRGBO(57, 73, 171, 1),
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: TextStyle(color: Color.fromRGBO(57, 73, 171, 1)),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.indigo[600],
                      )),
                ),
                SizedBox(height: 10),
                ListTile(
                  onTap: () {
                    _selectTime(context);
                  },
                  title: const Text(
                    'Select a Time',
                    style: TextStyle(
                        fontFamily: 'Merriweather',
                        color: Color.fromRGBO(57, 73, 171, 1),
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${selectedTime.hour}:${selectedTime.minute}",
                    style: TextStyle(color: Color.fromRGBO(57, 73, 171, 1)),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      icon: Icon(
                        Icons.alarm,
                        color: Colors.indigo[600],
                      )),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          document.reference.update({
                            "taskName": taskTitleEditController.text,
                            "taskDetail": taskDetailEditController.text,
                            "taskDate":
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                            "taskTime":
                                "${selectedTime.hour}:${selectedTime.minute}",
                          });
                          Navigator.pop(context);
                          taskTitleEditController.clear();
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 17, horizontal: 33)),
                          elevation: MaterialStateProperty.all(8),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color:
                                              Color.fromRGBO(57, 73, 171, 1)))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(57, 73, 171, 1)),
                        ),
                        child: Text(
                          "Update Task",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Merriweather',
                          ),
                        )),
                  ],
                ),
              ]),
            ),
          );
        });
  }

  _selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Color.fromRGBO(57, 73, 171, 1), // header background color
              // onPrimary: Colors.black, // header text color
              onSurface: Color.fromRGBO(57, 73, 171, 1), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color.fromRGBO(57, 73, 171, 1), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

//
//                       FUNCTION FOR TIME
//

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Color.fromRGBO(57, 73, 171, 1), // header background color
              onSurface: Color.fromRGBO(57, 73, 171, 1), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color.fromRGBO(57, 73, 171, 1), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}
