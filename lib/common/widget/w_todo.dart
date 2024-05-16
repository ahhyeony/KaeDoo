import 'package:kaedoo/common/common.dart';
import 'package:kaedoo/common/widget/round_button_theme.dart';
import 'package:kaedoo/common/widget/w_round_button.dart';
import 'package:kaedoo/screen/dialog/d_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaedoo/screen/opensource/vo_package.dart';

class Task {
  String work; // 할 일의 내용
  bool isComplete; // 할 일 완료 여부
  Task(this.work): isComplete = false; // 기본값: false
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
