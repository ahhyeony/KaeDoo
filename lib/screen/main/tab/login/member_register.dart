import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kaedoo/data/mysql/loginDB.dart';

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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('뒤로 가기'),
                        ),
                      ),
                      Text('   '),
                      //계정 생성
                      SizedBox(
                        width: 195,
                        child: ElevatedButton(
                          onPressed: () async {
                            // ID 중복확인
                            final idCheck = await confirmIdCheck(userId.text);
                            print("idCheck : $idCheck");

                            // 아이디 중복 => 1, 아니면 => 0
                            if (idCheck != '0') {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title : Text('알림'),
                                      content: Text('입력한 아이디가 이미 존재합니다'),
                                      actions: [
                                        TextButton(
                                          child: Text('닫기'),
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
                                          child: Text("닫기"),
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
                                        child: Text("닫기"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text("계정 생성"),
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
