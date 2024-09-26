import 'package:clg_calender/utils/utils.dart';
import 'package:clg_calender/views/clean_calender.dart';
import 'package:clg_calender/views/profile_page.dart';
import 'package:clg_calender/views/students_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  final String email;
  final String uUID;
  final UserType userType;
  const HomePage(
      {super.key,
      required this.userType,
      required this.email,
      required this.uUID});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    requestFirebasePermissions();
    subscribeFirebaseToken();
    super.initState();
  }

  Future requestFirebasePermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future subscribeFirebaseToken() async {
    await FirebaseMessaging.instance.subscribeToTopic('calender');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: const Text("Home"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Text(
                          "Welcome ${widget.email}",
                          style: const TextStyle(
                              //  color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 0.5,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            crossAxisCount: 2),
                    children: widget.userType == UserType.admin
                        ? [student(), calender(), profile()]
                        : [calender(), profile()],
                  ),
                ),
              ],
            )));
  }

  Widget student() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StudentsListPage()));
      },
      child: Card(
          //   color: Colors.deepPurple.shade200,
          child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset("assets/student.png"),
          )),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text("Students",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400))),
          ),
        ],
      )),
    );
  }

  Widget calender() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CleanCalender(
                      userType: widget.userType,
                    )));
      },
      child: Card(
          //   color: Colors.deepPurple.shade200,
          child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset("assets/logo.png"),
          )),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text("Calender",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400))),
          ),
        ],
      )),
    );
  }

  Widget profile() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      userUid: widget.uUID,
                      userType: widget.userType,
                    )));
      },
      child: Card(
          // color: Colors.deepPurple.shade200,
          child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: widget.userType == UserType.admin
                ? Image.asset("assets/admin.png")
                : Image.asset("assets/student.png"),
          )),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text("Profile",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w400))),
          ),
        ],
      )),
    );
  }
}
