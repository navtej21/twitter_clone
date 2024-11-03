import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showprogressindicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(
          child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ));
    },
  );
}

void hideprogressindicator(BuildContext context) {
  Navigator.pop(context);
}
