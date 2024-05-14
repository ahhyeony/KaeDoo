import 'package:kaedoo/common/common.dart';
import 'package:kaedoo/common/widget/round_button_theme.dart';
import 'package:kaedoo/common/widget/w_round_button.dart';
import 'package:kaedoo/screen/dialog/d_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaedoo/screen/opensource/vo_package.dart';

class todoList extends StatefulWidget {
  const todoList({super.key});

  @override
  State<todoList> createState() => _todoListState();
}

class _todoListState extends State<todoList> {
  String title = "";
  String description = "";
  List<ToDo> tds = [];
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: context.appColors.seedColor.getMaterialColorValues[100],
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff94B396),
              foregroundColor: Colors.white,
              leading:
              IconButton(onPressed: () => openDrawer(context),
                  icon: const Icon(Icons.menu)),
              centerTitle: true,
              title: Text("${now.year}.${now.month}.${now.day}"),
              actions: [
                IconButton(onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("나의 할일"),
                        actions: [
                          TextField(
                            decoration: InputDecoration(hintText: "글 제목"),
                          ),
                          TextField(
                            decoration: InputDecoration(hintText: "글 내용"),
                          ),
                          Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    //Navigator.pop(context);
                                    setState(() {
                                      tds.add(ToDo(
                                          title: title,
                                          description: description));
                                    });
                                  },
                                  child: Text("추가 하기")))
                        ],
                      );
                    },
                  );
                },
                    icon: Icon(Icons.add)),
              ],
            ),
            body: ListView.builder(
              itemBuilder: (_, index) {
                return InkWell(
                    child: ListTile(
                      title: Text(tds[index].title),
                      subtitle: Text(tds[index].description),
                    )
                );
              },
              itemCount: tds.length,
            )
        )
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}

class ToDo {
  final String title;
  final String description;

  ToDo({required this.title, required this.description});
}