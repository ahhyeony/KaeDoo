import 'package:kaedoo/common/common.dart';
import 'package:kaedoo/common/widget/round_button_theme.dart';
import 'package:kaedoo/common/widget/w_todo.dart';
import 'package:flutter/material.dart';

import '../../../dialog/d_color_bottom.dart';
import '../../../dialog/d_confirm.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return todoList();
  }
}