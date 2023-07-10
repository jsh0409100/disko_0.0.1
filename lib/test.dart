import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  final String payload;

  const TestScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);

  static const routeName = '/test-screen';

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.payload);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.payload),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the payload: ',
            ),
            Text(
              widget.payload,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}