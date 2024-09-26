import 'dart:developer';

import 'package:clg_calender/utils/utils.dart';
import 'package:clg_calender/views/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTFC = TextEditingController();
  final TextEditingController _passTFC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ClgCalender",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            labelText: "Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required!";
                          } else if (!isValidEmail(value)) {
                            return "Enter Valid Email!";
                          } else {
                            return null;
                          }
                        },
                        controller: _emailTFC,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            labelText: "Password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          } else {
                            return null;
                          }
                        },
                        controller: _passTFC,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                showLoading(context: context);
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: _emailTFC.text,
                                        password: _passTFC.text)
                                    .then((value) {
                                  log(value.user.toString());
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(
                                          userType:
                                              _emailTFC.text.contains("Admin")
                                                  ? UserType.admin
                                                  : UserType.student,
                                          email: value.user!.email.toString(),
                                          uUID: value.user!.uid.toString(),
                                        ),
                                      ),
                                      (Route<dynamic> route) => false);
                                }).catchError((e) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Error ${e.toString()}")));
                                });
                              }
                            },
                            child: const Text("Login")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
