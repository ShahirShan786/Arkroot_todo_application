import 'package:flutter/material.dart';

class DummyScreen extends StatelessWidget {
  final String text;

  const DummyScreen({super.key, this.text = "Dummy Screen"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}
