import 'package:arkroot_todo_app/core/presentation/utils/message_generator.dart';
import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(MessageGenerator.getMessage('sample-app-title')),),
    
    body: Center(
      child: Text(MessageGenerator.getMessage('sample-description')),
    ),
    );
  }
}