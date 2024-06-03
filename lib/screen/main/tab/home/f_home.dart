import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaedoo/common/widget/w_task_list.dart';
import 'package:kaedoo/common/widget/w_progress_bar.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final _textController = TextEditingController();
  List<Task> tasks = [];
  bool isModifying = false;
  int modifyingIndex = 0;
  double percent = 0.0;
  DateTime selectedDate = DateTime.now();  // 사용자가 선택한 날짜
  Map<String, List<Task>> tasksByDate = {};  // 날짜별 할 일 목록

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yy.MM.dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff94B396),
        title: InkWell(
          onTap: () => _selectDate(context),
          child: Text(
            formattedDate,
            style: const TextStyle(
              fontFamily: 'Jomhuria',
              fontSize: 50,
              color: Colors.white,
            ),
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
              ProgressBar(percent: percent),
              const SizedBox(height: 20),
              TaskList(
                tasks: tasksByDate[formattedDate] ?? [],
                onTasksUpdated: (updatedTasks) {
                  setState(() {
                    tasksByDate[formattedDate] = updatedTasks;
                    updatePercent(updatedTasks);
                  });
                },
                textController: _textController,
                isModifying: isModifying,
                modifyingIndex: modifyingIndex,
                onModify: (index, task) {
                  setState(() {
                    isModifying = true;
                    _textController.text = task.work;
                    modifyingIndex = index;
                  });
                },
                onModifyComplete: () {
                  setState(() {
                    isModifying = false;
                    _textController.clear();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePercent(List<Task> updatedTasks) {
    if (updatedTasks.isEmpty) {
      percent = 0.0;
    } else {
      int completeTaskCount = updatedTasks.where((task) => task.isComplete).length;
      percent = completeTaskCount / updatedTasks.length;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}