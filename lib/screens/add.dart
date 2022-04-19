import 'package:firebase/controllers/authentication.dart';
import 'package:firebase/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final String uid = Get.arguments;
  var taskcollections = FirebaseFirestore.instance.collection('users');

  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskDetail = TextEditingController();

  addData() async {
    await taskcollections.doc(uid).collection('task').add({
      "taskName": taskTitle.text,
      "taskDetail": taskDetail.text,
      "taskDate":
          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      "taskTime": "${selectedTime.hour}:${selectedTime.minute}",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo[600],
        title: Text(
          "Add Task",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Merriweather',
          ),
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: 40,
        ),
        //
        //                       TASK NAME
        //
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: taskTitle,
            style: TextStyle(color: Colors.indigo[600]),
            cursorColor: Colors.indigo[600],
            decoration: InputDecoration(
                enabledBorder: new UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(63, 81, 181, 1)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(63, 81, 181, 1)),
                ),
                labelText: 'Task Title',
                hintText: 'Enter Task Title',
                labelStyle: TextStyle(
                    fontFamily: 'Merriweather',
                    color: Color.fromRGBO(63, 81, 181, 1),
                    fontWeight: FontWeight.bold)),
          ),
        ),
        //
        //                       TASK DETAILS
        //
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: taskDetail,
            style: TextStyle(color: Colors.indigo[600]),
            cursorColor: Colors.indigo[600],
            decoration: InputDecoration(
                enabledBorder: new UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(63, 81, 181, 1)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(63, 81, 181, 1)),
                ),
                labelText: 'Task Details',
                hintText: 'Enter Task Details',
                labelStyle: TextStyle(
                    fontFamily: 'Merriweather',
                    color: Color.fromRGBO(63, 81, 181, 1),
                    fontWeight: FontWeight.bold)),
          ),
        ),
        //
        //                       TASK DATE
        //
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: ListTile(
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
        ),
        //
        //                       TASK TIME
        //
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: ListTile(
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
        ),
        SizedBox(
          height: 50,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 17, horizontal: 33)),
                elevation: MaterialStateProperty.all(8),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side:
                            BorderSide(color: Color.fromRGBO(57, 73, 171, 1)))),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(57, 73, 171, 1)),
              ),
              onPressed: () {
                setState(() {
                  addData();
                });
                taskTitle.clear();
                taskDetail.clear();
                selectedDate = DateTime.now();
                selectedTime = TimeOfDay.now();
                Get.back();
              },
              child: Text(
                "Add Task",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Merriweather',
                ),
              )),
          SizedBox(
            width: 25,
          )
        ]),
      ]),
    );
  }
  //
  //                     FUNCTION FOR DATE
  //

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
