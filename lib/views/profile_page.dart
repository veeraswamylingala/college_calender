import 'package:clg_calender/utils/utils.dart';
import 'package:clg_calender/views/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userUid;
  final UserType userType;
  const ProfilePage({super.key, required this.userType, required this.userUid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: const Text("Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Students')
                  .where('uid', isEqualTo: widget.userUid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  Map<String, dynamic> data =
                      snapshot.data!.docs[0].data() as Map<String, dynamic>;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                            color: Theme.of(context).primaryColor,
                            child: SizedBox(
                              height: 100,
                              child: Image.asset(
                                widget.userType == UserType.admin
                                    ? "assets/admin.png"
                                    : "assets/student.png",
                                fit: BoxFit.contain,
                              ),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          child: ListTile(
                            title: Text(
                                data['first_name'] + " " + data['last_name']),
                            subtitle: const Text("Name"),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: Text(data['email']),
                            subtitle: const Text("Email"),
                          ),
                        ),
                        if (widget.userType == UserType.student)
                          Card(
                            child: ListTile(
                              title: Text(data['branch']),
                              subtitle: const Text("Branch"),
                            ),
                          ),
                        if (widget.userType == UserType.student)
                          Card(
                            child: ListTile(
                              title: Text(data['section']),
                              subtitle: const Text("Section"),
                            ),
                          ),
                        if (widget.userType == UserType.student)
                          Card(
                            child: ListTile(
                              title: Text(data['roll_no']),
                              subtitle: const Text("Roll No"),
                            ),
                          ),
                        const Card(
                          child: ListTile(
                            title: Text("Status"),
                            subtitle: Text("Active"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Card(
                          child: ListTile(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (Route<dynamic> route) => false);
                            },
                            trailing: const Icon(Icons.arrow_right),
                            title: const Text("Logout"),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }),
        ));
  }
}
