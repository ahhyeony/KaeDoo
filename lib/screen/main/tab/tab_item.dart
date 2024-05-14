import 'package:cached_network_image/cached_network_image.dart';
import 'package:kaedoo/common/common.dart';
import 'package:kaedoo/screen/main/tab/calendar/f_calendar.dart';
import 'package:kaedoo/screen/main/tab/timer/f_timer.dart';
import 'package:kaedoo/screen/main/tab/home/f_home.dart';
import 'package:flutter/material.dart';

enum TabItem {
  home(Icons.home, '홈', HomeFragment()),
  timer(Icons.timer, '타이머', TimerFragment()),
  calendar(Icons.calendar_today, '캘린더', FavoriteFragment1(isShowBackButton: false));


  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color:
              isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}
