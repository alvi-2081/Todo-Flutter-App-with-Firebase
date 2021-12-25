import 'package:firebase/controllers/authentication.dart';
import 'package:firebase/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final String uid = Get.arguments;
  var taskcollections = FirebaseFirestore.instance.collection('users');

  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskDetail = TextEditingController();
  TextEditingController taskTime = TextEditingController();

  addData() async {
    await taskcollections.doc(uid).collection('task').add({
      "taskName": taskTitle.text,
      "taskDetail": taskDetail.text,
      "taskTime": taskTime.text,
      "date":
          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600],
        title: Text("Add Task"),
      ),
      body: Column(children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Title',
                hintText: 'Enter Task Title'),
            controller: taskTitle,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Details',
                hintText: 'Enter Task Details'),
            controller: taskDetail,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Time',
                hintText: 'Enter Task Time'),
            controller: taskTime,
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.indigo),
              ),
              onPressed: () {
                setState(() {
                  addData();
                });
                taskTitle.clear();
                taskDetail.clear();
                taskTime.clear();
                Get.back();
              },
              child: Text("Add Task")),
        ]),
      ]),
    );
  }
}
