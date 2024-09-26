import 'package:flutter/material.dart';

bool isValidEmail(String value) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value);
}

showLoading({
  required BuildContext context,
}) {
  return showDialog(
    //prevent outside touch
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      //prevent Back button press
      return PopScope(
          onPopInvoked: (va) async => false,
          child: const AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: SizedBox(
              height: 50,
              width: 20,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ));
    },
  );
}

enum UserType { admin, student }
