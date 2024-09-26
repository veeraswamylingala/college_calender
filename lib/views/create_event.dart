import 'package:clg_calender/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatefulWidget {
  final DateTime selectedDate;
  const CreateEvent({super.key, required this.selectedDate});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _titleTFC = TextEditingController();
  final TextEditingController _subtitleTFC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required!";
                    } else if (value.length < 3) {
                      return "Enter be above 3 characters!";
                    } else {
                      return null;
                    }
                  },
                  controller: _titleTFC,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      labelText: "Sub Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required!";
                    } else if (value.length < 3) {
                      return "Enter be above 3 characters!";
                    } else {
                      return null;
                    }
                  },
                  controller: _subtitleTFC,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: DateFormat("yyyy-MM-dd").format(
                    widget.selectedDate,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      labelText: "Date"),
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
                          addCalenderEvent(data: {
                            "event_title": _titleTFC.text,
                            "event_subtitle": _subtitleTFC.text,
                            "event_date": DateFormat("yyyy-MM-dd").format(
                              widget.selectedDate,
                            ),
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
    );
  }

  Future addCalenderEvent({required Map<String, dynamic> data}) async {
    CollectionReference calender =
        FirebaseFirestore.instance.collection('Calender');
    calender.add(data).then((value) {
      Navigator.pop(context, true);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New Event Added Successfully!")));
    }).catchError((error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Error Try again after some time! ${error.toString()}")));
    });
  }
}
