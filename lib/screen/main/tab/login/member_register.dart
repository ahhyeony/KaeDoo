import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaedoo/data/mysql/loginDB.dart';
import 'login.dart';

class MemberRegister extends StatefulWidget {
  const MemberRegister({super.key});

  @override
  State<MemberRegister> createState() => _MemberRegisterState();
}

class _MemberRegisterState extends State<MemberRegister> {

  final TextEditingController userId = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordVerifying = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold (
        backgroundColor: Color(0xff94B396),
        body: Center (
          // 아이디
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: CupertinoTextField (
                      cursorColor: Color(0xff94B396),
                      controller: userId,
                      placeholder: "아이디를 입력해주세요",
                      textAlign: TextAlign.center,
                    )
                  )
                ),
                // 비밀번호
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: CupertinoTextField (
                      cursorColor: Color(0xff94B396),
                      controller: password,
                      placeholder: "비밀번호를 입력해주세요",
                      textAlign: TextAlign.center,
                      obscureText: true,
                    )
                  )
                ),
                // 비밀번호 다시 확인
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField (
                        cursorColor: Color(0xff94B396),
                        controller: passwordVerifying,
                        placeholder: "비밀번호를 다시 입력해주세요",
                        textAlign: TextAlign.center,
                        obscureText: true,
                    )
                  )
                ),
                // 로그인 페이지로 돌아가기
                Padding (
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 95,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 2.0, color: Colors.white)
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '뒤로 가기',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      Text('   '),
                      //계정 생성
                      SizedBox(
                        width: 195,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffD2E7D3)
                            ),
                          onPressed: () async {
                            // ID 중복확인
                            final idCheck = await confirmIdCheck(userId.text);
                            print("idCheck : $idCheck");

                            // 하나라도 입력되지 않은 경우
                            if (userId.text.isEmpty || password.text.isEmpty || passwordVerifying.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("알림"),
                                    content: Text("빈칸을 모두 채워주세요."),
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
                            }
                            // 아이디 중복 => 1, 아니면 => 0
                            else if (idCheck != '0') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title : Text('알림'),
                                      content: Text('입력한 아이디가 이미 존재합니다'),
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
                              }
                            // 비밀번호가 다른 경우
                            else if (password.text != passwordVerifying.text) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("입력한 비밀번호가 같지 않습니다"),
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
                              }
                            // DB 계정 등록
                            else {
                              insertMember(userId.text, password.text);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("알림"),
                                    content: Text("계정이 생성되었습니다"),
                                    actions: [
                                      TextButton(
                                        child: Text("닫기", style: TextStyle(color: Color(0xff94B396))),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => LoginMain())
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                              "계정 생성",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        )
                      )
                      )
                    ],
                  )
                )
              ],
            )
          )
        )
      )
    );
  }
}
