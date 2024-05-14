import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = Duration(seconds: 4);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
              decoration: BoxDecoration(color: Color(0xff94B396)),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "KaeDoo",
                            style: TextStyle(
                                fontFamily: 'Jomhuria',
                                fontSize: 100,
                                color: Colors.white,
                                height: 0.5
                            )
                        ),
                        Text(
                            "깨어있는 두뇌",
                            style: TextStyle(
                                fontFamily: 'Jomhuria',
                                fontSize: 15,
                                color: Colors.white
                            )
                        )
                      ]
                  )
              ),
            )
        )
    );
  }
}
