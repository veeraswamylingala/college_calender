import 'dart:developer';

import 'package:clean_calendar/clean_calendar.dart';
import 'package:clg_calender/utils/utils.dart';
import 'package:clg_calender/views/create_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CleanCalender extends StatefulWidget {
  final UserType userType;
  const CleanCalender({super.key, required this.userType});

  @override
  State<CleanCalender> createState() => _CleanCalenderState();
}

class _CleanCalenderState extends State<CleanCalender> {
  Stream<QuerySnapshot> _calenderStream =
      FirebaseFirestore.instance.collection('Calender').snapshots();

  List<DocumentSnapshot> calenderEvents = [];

  DocumentSnapshot? selectedEvent;
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Calender"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
                stream: _calenderStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    calenderEvents = snapshot.data!.docs;
                    // calenderEvents.addAll(data
                    //     .map((DocumentSnapshot e) =>
                    //         e)
                    //     .toList());
                    //setState(() {});

                    return Column(
                      children: [
                        CleanCalendar(
                            selectedDates: [selectedDate],
                            selectedDatesProperties: DatesProperties(
                              datesDecoration: DatesDecoration(
                                  datesBorderColor:
                                      Theme.of(context).primaryColor,
                                  datesBackgroundColor: Colors.white,
                                  datesTextColor:
                                      Theme.of(context).primaryColor,
                                  datesTextStyle: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold)),
                            ),
                            dateSelectionMode:
                                DatePickerSelectionMode.singleOrMultiple,
                            currentDateProperties: DatesProperties(
                                datesDecoration: DatesDecoration(
                                    datesTextColor: Colors.white,
                                    datesBackgroundColor:
                                        Theme.of(context).primaryColor)),
                            streakDatesProperties: DatesProperties(
                                datesDecoration: DatesDecoration(
                                    datesTextColor: Colors.white,
                                    datesBackgroundColor: Colors.redAccent)),
                            onCalendarViewDate: (value) {
                              log(value.toString(), name: "onCalendarViewDate");
                            },
                            onSelectedDates: (value) {
                              log(value.toString(), name: "onSelectedDates");
                              if (value.length == 1) {
                                var i = calenderEvents.where((e) {
                                  var element =
                                      e.data() as Map<String, dynamic>;
                                  DateTime date = DateTime.parse(
                                      element['event_date'].toString());
                                  return DateTime(
                                          date.year, date.month, date.day) ==
                                      DateTime(value[0].year, value[0].month,
                                          value[0].day);
                                }).toList();

                                //if selected data contains in list then its a event else no event
                                if (i.isNotEmpty) {
                                  setState(() {
                                    selectedDate = value[0];
                                    selectedEvent = i[0];
                                  });
                                } else {
                                  setState(() {
                                    selectedDate = value[0];
                                    selectedEvent = null;
                                  });
                                }
                              }
                            },
                            datesForStreaks: calenderEvents.map((e) {
                              var data = e.data() as Map<String, dynamic>;
                              return DateTime.parse(data['event_date']);
                            }).toList()),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                dateWidget(),
                                                selectedEvent != null
                                                    ? eventView()
                                                    : const Text(
                                                        "No Events Found",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black26,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          editItemsWidgets()
                                        ]))))
                      ],
                    );
                  }
                })));
  }

  editItemsWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Visibility(
        //   visible: selectedEvent != null && widget.userType == UserType.admin,
        //   child: TextButton(
        //       style: TextButton.styleFrom(
        //           backgroundColor: Theme.of(context).primaryColor,
        //           foregroundColor: Colors.white),
        //       onPressed: () {},
        //       child: const Icon(Icons.notifications)),
        // ),
        // const SizedBox(
        //   width: 3,
        // ),
        // Visibility(
        //   visible: selectedEvent != null && widget.userType == UserType.admin,
        //   child: TextButton(
        //       style: TextButton.styleFrom(
        //           backgroundColor: Theme.of(context).primaryColor,
        //           foregroundColor: Colors.white),
        //       onPressed: () {},
        //       child: const Icon(Icons.edit)),
        // ),
        // const SizedBox(
        //   width: 3,
        // ),
        Visibility(
          visible: selectedEvent != null && widget.userType == UserType.admin,
          child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white),
              onPressed: () {
                showLoading(context: context);
                deleteRecord();
              },
              child: const Icon(Icons.delete)),
        ),
        Visibility(
          visible: selectedEvent == null &&
              selectedDate.isAfter(DateTime.now()) &&
              widget.userType == UserType.admin,
          child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateEvent(selectedDate: selectedDate)))
                    .then((value) {
                  _calenderStream = FirebaseFirestore.instance
                      .collection('Calender')
                      .snapshots();

                  setState(() {
                    selectedDate = DateTime.now();
                  });
                });
              },
              child: const Icon(Icons.add)),
        ),
      ],
    );
  }

  Widget dateWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                child: Text(selectedDate.day.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(DateFormat.MMMM().format(selectedDate)),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        const Expanded(
          flex: 5,
          child: Divider(
            color: Colors.grey,
            thickness: 1,
            height: 1,
          ),
        )
      ],
    );
  }

  Widget eventView() {
    var data = selectedEvent!.data() as Map<String, dynamic>;
    return Row(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 1.5)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['event_title'],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['event_subtitle'],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

//Delete Firestore record based on Record id-
  Future deleteRecord() async {
    CollectionReference calender =
        FirebaseFirestore.instance.collection('Calender');
    calender.doc(selectedEvent!.id).delete().then((value) {
      _calenderStream =
          FirebaseFirestore.instance.collection('Calender').snapshots();
      setState(() {
        selectedDate = DateTime.now();
      });
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event Deleted Successfully!")));
    }).catchError((error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Error Try again after some time! ${error.toString()}")));
    });
  }
}
