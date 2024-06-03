import 'package:flutter/material.dart';

class Task {
  String work;
  bool isComplete;
  Task(this.work, {this.isComplete = false});
}

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  final ValueChanged<List<Task>> onTasksUpdated;
  final TextEditingController textController;
  final bool isModifying;
  final int modifyingIndex;
  final Function(int, Task) onModify;
  final VoidCallback onModifyComplete;

  TaskList({
    required this.tasks,
    required this.onTasksUpdated,
    required this.textController,
    required this.isModifying,
    required this.modifyingIndex,
    required this.onModify,
    required this.onModifyComplete,
  });

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInputField(),
        const SizedBox(height: 5),
        _buildTaskList(),
      ],
    );
  }

  Widget _buildInputField() {
    return Container(
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
              controller: widget.textController,
              decoration: InputDecoration(
                hintText: 'Enter a task',
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xff94B396), width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              if (widget.textController.text.isEmpty) {
                return;
              } else {
                setState(() {
                  if (widget.isModifying) {
                    widget.tasks[widget.modifyingIndex].work = widget.textController.text;
                    widget.tasks[widget.modifyingIndex].isComplete = false;
                    widget.onModifyComplete();
                  } else {
                    widget.tasks.add(Task(widget.textController.text));
                  }
                  widget.textController.clear();
                  widget.onTasksUpdated(widget.tasks);
                });
              }
            },
            child: widget.isModifying ? const Text("수정", style: TextStyle(color: Colors.white)) : const Text("추가", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              backgroundColor: const Color(0xff94B396),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Container(
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
      height: MediaQuery.of(context).size.height * 0.6,
      child: widget.tasks.isNotEmpty
          ? ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
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
                        widget.onTasksUpdated(widget.tasks);
                      });
                    },
                    child: Row(
                      children: [
                        task.isComplete
                            ? const Icon(Icons.check_box_rounded)
                            : const Icon(Icons.check_box_outline_blank_rounded),
                        const SizedBox(width: 10),
                        Text(
                          task.work,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.isModifying
                      ? null
                      : () {
                    widget.onModify(index, task);
                  },
                  child: const Text("수정"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      widget.tasks.removeAt(index);
                      widget.onTasksUpdated(widget.tasks);
                    });
                  },
                  child: const Text("삭제"),
                ),
              ],
            ),
          );
        },
      )
          : const Center(
        child: Text(
          'No tasks available',
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      ),
    );
  }
}
