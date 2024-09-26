import 'dart:developer';

import 'package:clg_calender/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//Create new student with below detials and store them in firebase clous in students collection --
//and also each studnet login email and password to firebase authentication once done sent notification to registered email
//create auto pasword button with in password field
class NewStudentPage extends StatefulWidget {
  const NewStudentPage({super.key});

  @override
  State<NewStudentPage> createState() => _NewStudentPageState();
}

class _NewStudentPageState extends State<NewStudentPage> {
  CollectionReference studnets =
      FirebaseFirestore.instance.collection('Students');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTFC = TextEditingController();
  final TextEditingController _lastNameTFC = TextEditingController();
  final TextEditingController _emailTFC = TextEditingController();
  final TextEditingController _passTFC = TextEditingController();
  final TextEditingController _rollNoTFC = TextEditingController();
  String? selectedBranch;
  String? selectedSection;

  InputDecoration decoratin({required String labelName}) {
    return InputDecoration(
        filled: true, fillColor: Colors.grey.shade300, labelText: labelName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Student")),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _nameTFC,
                      onChanged: (value) {
                        //add auto generated password here
                        _generatePassword();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        } else if (value.length < 4) {
                          return "Must be above 4 charcaters!";
                        } else {
                          return null;
                        }
                      },
                      decoration: decoratin(labelName: "First Name")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _lastNameTFC,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        } else if (value.length < 3) {
                          return "Must be above 3 charcaters!";
                        } else {
                          return null;
                        }
                      },
                      decoration: decoratin(labelName: "Last Name")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _emailTFC,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required!";
                        } else if (!isValidEmail(value)) {
                          return "Enter Valid Email!";
                        } else {
                          return null;
                        }
                      },
                      decoration: decoratin(labelName: "Email")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _rollNoTFC,
                      onChanged: (value) {
                        //add auto generated password here
                        _generatePassword();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        } else if (value.length < 3) {
                          return "Must be above 3 charcaters!";
                        } else {
                          return null;
                        }
                      },
                      decoration: decoratin(labelName: "Roll No")),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: decoratin(labelName: "Branch"),
                    value: selectedBranch,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else {
                        return null;
                      }
                    },
                    items: ["CSE", "MEC", "ECE", "EEE", "CIVIL"].map((branch) {
                      return DropdownMenuItem(
                        value: branch,
                        child: Text(branch),
                      );
                    }).toList(),
                    onChanged: (branch) {
                      setState(() {
                        selectedBranch = branch;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: decoratin(labelName: "Section"),
                    value: selectedSection,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      } else {
                        return null;
                      }
                    },
                    items: ["A", "B", "C", "D"].map((branch) {
                      return DropdownMenuItem(
                        value: branch,
                        child: Text(branch),
                      );
                    }).toList(),
                    onChanged: (section) {
                      setState(() {
                        selectedSection = section;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      obscureText: true,
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _passTFC,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              //add auto generated password here
                              _generatePassword();
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          labelText: "Password")),
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "This field will generate password automatically!",
                      style: TextStyle(fontSize: 10),
                    ),
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
                            addUser(data: {
                              "first_name": _nameTFC.text,
                              "last_name": _lastNameTFC.text,
                              "email": _emailTFC.text,
                              "user_type": "student",
                              "roll_no": _rollNoTFC.text,
                              "branch": selectedBranch,
                              "section": selectedSection,
                              "password": _passTFC.text
                            });
                          }
                        },
                        child: const Text("Submit")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future addUser({required Map<String, dynamic> data}) async {
//create useremail and password then store data in fisrestore users ---
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: data['email'], password: data['password'])
        .then((user) {
      Map userValues = data;
      userValues['uid'] = user.user!.uid.toString();
      // Call the user's CollectionReference to add a new user
      studnets.add(userValues).then((value) {
        Navigator.pop(context, true);
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("New Student Added Successfully!")));
      }).catchError((error) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Error Try again after some time! ${error.toString()}")));
      });
    }).catchError((e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error Try again after some time! ${e.toString()}")));
    });
  }

  void _generatePassword() {
    String password = "";
    if (_nameTFC.text.isNotEmpty && _rollNoTFC.text.isNotEmpty) {
      password = "${_nameTFC.text.substring(0, 3)}-${_rollNoTFC.text}";
      setState(() {
        _passTFC.text = password;
      });
    }
  }
}
