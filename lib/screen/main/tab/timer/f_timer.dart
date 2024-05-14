import 'package:flutter/material.dart';
import 'package:kaedoo/common/widget/w_timer.dart';  // TimerWidget을 포함한 파일의 경로가 정확해야 합니다.

class TimerFragment extends StatelessWidget {
  final bool showBackButton;

  const TimerFragment({
    Key? key,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showBackButton ? AppBar(
        title: Text('Timer'),
        leading: BackButton(),
      ) : null,
      body: Center(
        child: TimerWidget(),
      ),
    );
  }
}
