import 'package:clg_calender/views/add_new_student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//Fetch all List of users info from firebase store collection students and show it here ---------------------
class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Students')
      .where('user_type', isEqualTo: "student")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Students"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewStudentPage()))
                .then((value) {
              if (value == true) {
                setState(() {});
              }
            });
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Total Students :${snapshot.data!.docs.length}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return Card(
                              elevation: 1.0,
                              child: ListTile(
                                leading: Image.asset("assets/student.png"),
                                title: Text(data['first_name'] +
                                    " " +
                                    data['last_name']),
                                subtitle: Text(
                                    "${data['roll_no']} : ${data['branch']}: ${data['section']} "),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  );
                }
              }),
        ));
  }
}
