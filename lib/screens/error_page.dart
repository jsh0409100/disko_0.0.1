import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.e, this.trace);

  final Object e;
  final StackTrace trace;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(""));
  }
}
