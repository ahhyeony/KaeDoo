import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaedoo/data/mysql/loginDB.dart';
import 'package:kaedoo/app.dart';
import 'package:kaedoo/screen/main/s_main.dart';
import 'member_register.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Login()
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // 자동 로그인 여부
  bool switchValue = false;

  // 아이디와 비밀번호 정보
  final TextEditingController userId = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff94B396),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ID 입력 텍스트필드
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: CupertinoTextField(
                      cursorColor: Color(0xff94B396),
                      controller: userId,
                      placeholder: '아이디를 입력해주세요',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // 비밀번호 입력 텍스트필드
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: CupertinoTextField(
                      cursorColor: Color(0xff94B396),
                      controller: password,
                      placeholder: '비밀번호를 입력해주세요',
                      textAlign: TextAlign.center,
                      obscureText: true,
                    ),
                  ),
                ),
                // 자동 로그인 확인 토글 스위치
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '자동로그인 ',
                        style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      CupertinoSwitch(
                        // 부울 값으로 스위치 토글 (value)
                        value: switchValue,
                        activeColor: CupertinoColors.white,
                        onChanged: (bool? value) {
                          // 스위치가 토글될 때 실행될 코드
                          setState(() {
                            switchValue = value ?? false;
                          });
                        },
                      ),
                      Text('    '),
                      // 계정 생성 페이지로 이동하는 버튼
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 2.0, color: Colors.white)
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MemberRegister(),
                            ),
                          );
                        },
                        child: Text(
                          '계정생성',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 로그인 버튼
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffD2E7D3)
                      ),
                      onPressed: () async {
                        final loginCheck = await login(
                            userId.text, password.text);
                        print(loginCheck);

                        // 로그인 확인
                        if (loginCheck == '-1') {
                          print('로그인 실패');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('알림'),
                                content: Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
                                actions: [
                                  TextButton(
                                    child: Text("닫기", style: TextStyle(color: Color(0xff94B396))),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          print('로그인 성공');

                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (BuildContext context) {
                          //     return Center(child: CircularProgressIndicator());
                          //   },
                          // );
                          // await Future.delayed(Duration(seconds: 1)); // 1초 동안 지연
                          // if (Navigator.canPop(context)) {
                          //   Navigator.pop(context); // 로딩 다이얼로그 닫기
                          // }

                          // 메인 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => App(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '로그인',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





