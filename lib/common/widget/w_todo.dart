import 'package:flutter/material.dart';

class Task {
  String work;
  bool isComplete;
  Task(this.work): isComplete = false;
}

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

}
