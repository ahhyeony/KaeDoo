import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

// Task 클래스 정의
class Task {
  String work;
  bool isComplete;

  Task(this.work, {this.isComplete = false});
}

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final _textController = TextEditingController();
  List<Task> tasks = []; // 할 일 목록
  bool isModifying = false; // 수정 여부
  int modifyingIndex = 0; // 수정 인덱스
  double percent = 0.0; // 진척도

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff94B396),
        title: Text(
          getToday(),
          style: TextStyle(
            fontFamily: 'Jomhuria',
            fontSize: 50,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => openDrawer(context),
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            children: [
              // Add task input field and button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Enter a task',
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff94B396), width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_textController.text.isEmpty) {
                          return;
                        } else {
                          isModifying
                              ? setState(() {
                            tasks[modifyingIndex].work = _textController.text;
                            tasks[modifyingIndex].isComplete = false;
                            _textController.clear();
                            modifyingIndex = 0;
                            isModifying = false;
                          })
                              : setState(() {
                            var task = Task(_textController.text);
                            tasks.add(task);
                            _textController.clear();
                          });
                          updatePercent();
                        }
                      },
                      child: isModifying ? const Text("수정", style: TextStyle(color: Colors.white)) : const Text("추가", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        backgroundColor: Color(0xff94B396),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              // 할 일 진행도를 나타내는 progress bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 14.0,
                      percent: percent,
                      backgroundColor: Color(0x50D3D3D3),
                      progressColor: Color(0xff94B396),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              // 할 일 목록
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                height: MediaQuery.of(context).size.height * 0.6,  // 할 일 목록 공간을 더 크게 설정
                child: tasks.isNotEmpty
                    ? ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  task.isComplete = !task.isComplete;
                                  updatePercent();
                                });
                              },
                              child: Row(
                                children: [
                                  task.isComplete
                                      ? const Icon(Icons.check_box_rounded)
                                      : const Icon(Icons.check_box_outline_blank_rounded),
                                  SizedBox(width: 10),
                                  Text(
                                    task.work,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: isModifying
                                ? null
                                : () {
                              setState(() {
                                isModifying = true;
                                _textController.text = task.work;
                                modifyingIndex = index;
                              });
                            },
                            child: const Text("수정"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                tasks.removeAt(index);
                                updatePercent();
                              });
                            },
                            child: const Text("삭제"),
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : Center(
                  child: Text(
                    'No tasks available',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yy.MM.dd');
    return format.format(now);
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void updatePercent() {
    if (tasks.isEmpty) {
      percent = 0.0;
    } else {
      var completeTaskCnt = tasks.where((task) => task.isComplete).length;
      percent = completeTaskCnt / tasks.length;
    }
  }
}
