import 'package:flutter/material.dart';
import 'package:kaedoo/common/theme/color/timer_app_colors.dart';

enum TabItem {
  home(Icons.home, '홈'),
  timer(Icons.timer, '타이머'),
  calendar(Icons.calendar_today, '캘린더');

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;

  const TabItem(this.activeIcon, this.tabName, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
      icon: Icon(
        key: ValueKey(tabName),
        isActivated ? activeIcon : inActiveIcon,
        color: isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
      ),
      label: tabName,
    );
  }
}