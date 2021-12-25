import 'package:firebase/controllers/authentication.dart';
import 'package:firebase/screens/add.dart';
import 'package:firebase/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  updateDialog(DocumentSnapshot<Object?> document) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update Task"),
            content: Column(
              children: [
                TextField(
                  controller: taskEditController,
                ),
                ElevatedButton(
                    onPressed: () {
                      document.reference
                          .update({"taskName": taskEditController.text});
                      Navigator.pop(context);
                      taskEditController.clear();
                    },
                    child: Text("Update"))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //
        //                            APPBAR STARTS
        //
        appBar: AppBar(
          backgroundColor: Colors.indigo[600],
          title: Text("Todo"),
        ),
        //
        //                            DRAWER STARTS
        //
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountEmail: Text("abdullah"),
                accountName: Text("abdullah"),
              ),
              SizedBox(
                height: 8,
              ),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () => signOutUser().whenComplete(() async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false);
                      })),
              SizedBox(
                height: 8,
              ),
              ListTile(
                  leading: Icon(Icons.info), title: Text("About"), onTap: () {})
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
                        color: Colors.indigo[200],
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          title: Text(
                            data['taskName'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            data['taskDetail'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(data['taskTime'],
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    document.reference.delete();
                                  },
                                  icon: Icon(Icons.delete)),
                              IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    updateDialog(document);
                                  },
                                  icon: Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ))
            ],
          ),
        ));
  }

  TextEditingController taskEditController = TextEditingController();
}

// actions: [
//   IconButton(
//       icon: Icon(Icons.logout),
//       color: Colors.white,
//       onPressed: () => signOutUser().whenComplete(() async {
//             Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => Login()),
//                 (Route<dynamic> route) => false);
//           }))
// ],

// SizedBox(
//   height: 8,
// ),
// ListTile(
//   leading: Icon(Icons.shopping_cart),
//   title: Text("Cart"),
// ),
// SizedBox(
//   height: 8,
// ),
// ListTile(
//   leading: Icon(Icons.favorite),
//   title: Text("Favourite"),
// ),

// Column(children: [
//   Container(
//     margin: EdgeInsets.symmetric(horizontal: 10),
//     padding: EdgeInsets.all(10),
//     child: TextField(
//       decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: 'Title',
//           hintText: 'Enter Task Title'),
//       controller: taskTitle,
//     ),
//   ),
//   Container(
//     margin: EdgeInsets.symmetric(horizontal: 10),
//     padding: EdgeInsets.all(10),
//     child: TextField(
//       decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: 'Details',
//           hintText: 'Enter Task Details'),
//       controller: taskDetail,
//     ),
//   ),
//   Container(
//     margin: EdgeInsets.symmetric(horizontal: 10),
//     padding: EdgeInsets.all(10),
//     child: TextField(
//       decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: 'Time',
//           hintText: 'Enter Task Time'),
//       controller: taskTime,
//     ),
//   ),
//   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//     ElevatedButton(
//         style: ButtonStyle(
//           backgroundColor:
//               MaterialStateProperty.all<Color>(Colors.brown),
//         ),
//         onPressed: () {
//           setState(() {
//             addData();
//           });
//           taskTitle.clear();
//           taskDetail.clear();
//           taskTime.clear();
//         },
//         child: Text("Add Task")),
//   ]),
// ]),
