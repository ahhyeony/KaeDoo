import 'package:kaedoo/common/common.dart';
import 'package:kaedoo/common/theme/custom_theme.dart';
import 'package:kaedoo/common/widget/round_button_theme.dart';
import 'package:kaedoo/common/widget/w_todo.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
        title: Text(getToday(), style: TextStyle(fontFamily: 'Jomhuria', fontSize: 50, color: Colors.white)),
        leading: IconButton(
          onPressed: () => openDrawer(context),
          icon: const Icon(Icons.menu, color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Center (
          child: Column(
            children: [
              // add 버튼
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(flex: 1, child: TextField(controller: _textController,)),
                      ElevatedButton(onPressed: () { // 할 일 추가
                        if (_textController == "")
                          return;
                        else {
                          isModifying
                          ? setState( () {
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
                      }, child: isModifying? const Text("수정") : const Text("추가")),
                    ],
                  )
              ),
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
                        backgroundColor: Colors.white38,
                        progressColor: Color(0xff94B396),
                      )
                    ],
                  )
              ),
              // 할 일 목록
              for (var i = 0; i<tasks.length; i++)
                Row(
                  children: [
                    Flexible(child: TextButton(
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))
                      ),
                      onPressed: () {
                        setState(() {
                          tasks[i].isComplete = !tasks[i].isComplete;
                          updatePercent();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            tasks[i].isComplete
                            ? const Icon(Icons.check_box_rounded)
                            : const Icon(Icons.check_box_outline_blank_rounded)
                            , Text(" "+tasks[i].work, style: Theme.of(context).textTheme.labelMedium)
                          ],
                        )
                      )
                    )
                    ),
                    TextButton(
                        onPressed: isModifying ? null : () {
                          setState(() {
                            isModifying = true;
                            _textController.text = tasks[i].work;
                            modifyingIndex = i;
                          });
                          },
                        child: const Text("수정")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            tasks.remove(tasks[i]);
                            updatePercent();
                          });
                        },
                        child: const Text("식제")),
                  ],
                )
            ],
          )
        )
      )
    );
  }

  String getToday(){
    DateTime now = DateTime.now();
    String strToday;
    DateFormat format = DateFormat('yy.MM.dd');
    strToday = format.format(now);
    return strToday;
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void updatePercent() {
    if(tasks.isEmpty)
      percent = 0.0;
    else {
      var completeTaskCnt = 0;
      for (var i = 0; i<tasks.length; i++){
        if (tasks[i].isComplete)
          completeTaskCnt += 1;
      }
      percent = completeTaskCnt / tasks.length;
    }
  }
}
