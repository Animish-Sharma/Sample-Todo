import 'package:flutter/material.dart';

class RequestDialog {
  static show(BuildContext context, String authError) {
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("OK"),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text("an error occurred"),
      content: Text(authError),
      actions: <Widget>[okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return alertDialog;
      },
    );
  }
}
