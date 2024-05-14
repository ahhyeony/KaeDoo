A new Flutter project.

##Object-File name

Widget-w_{name}.dart : 위젯
Screen-s_{name}.dart : 전체 디바이스를 덮는 화면
Fragment-f_{name}.dart : Screen 내부에 일부로 존재하는 콘 화면 Widget
Dialog-d_{name}.dart : Dialog 혹은 Bottom Sheet
Value Object-vo_{name}.dart : UI에서 사용하는 객체
Data Transfer Object-dto_{name}.dart : 통신이나 데이터 저장에 사용되는 객체
나머지-소문자,숫자,_조합

---

###240515 오전 05:33
스플래시 스크린 : 적용 완료
투두 리스트(홈) : 입력까지 가능하나, 저장이 안 됨 (assertion failed)
타이머 : start 누르고 나면 stop/restart로 바뀌는 거 보고 기존 restart와 혼동이 있을 것 같아 기존의 restart -> reset 으로 변경