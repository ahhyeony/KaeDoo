import 'package:flutter/material.dart';
import 'package:kaedoo/screen/main/tab/tab_item.dart';
import 'package:kaedoo/screen/main/tab/timer/f_timer.dart';
import 'package:kaedoo/screen/main/tab/home/f_home.dart';
import 'package:kaedoo/screen/main/tab/calendar/f_calendar.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    super.key,
    required this.tabItem,
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (tabItem) {
              case TabItem.home:
                return HomeFragment();
              case TabItem.timer:
                return TimerFragment();
              case TabItem.calendar:
                return FavoriteFragment1(isShowBackButton: false);
              default:
                return HomeFragment();
            }
          },
        );
      },
    );
  }
}
