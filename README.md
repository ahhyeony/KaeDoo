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

###240515 오후 18:46
새로추가한 파일
w_calendar.dart
-캘린더위젯
w_timedata.dart
-캘린더하단에 시간통계위젯
w_wtimedata.dart
-주간 공부시간 통계 위젯. 목록탭으로 일간/주간/월간 등등 하려고 했는데 컴터 다운당해서 일단 따로 파서 구현함
#수정한 파일
pub spec.yaml. -> table_calendar, pie_chart 추가
-캘린더, 그래프
dto_timestorage.dart, w_timerecord.dart, tab_navigator.dart
-이것저것 변수 조정하면서 만지다 일단 실행 가능하게 수정함
w_timerdata.dart
-일간 공부시간 통계 위젯
f_calendar.dart, f_timer.dart
-디자인하려고 했는데 먼가 얽힘. 다시봐야할듯.

###240516 오전 11:47
의존성 추가: percent_indicator: ^4.0.1 (퍼센트를 바로 나타내는 라이브러리)
lint 끄기
투두 : 작업 추가, 수정, 삭제, 진척도 구현 완료
버그 : 투두 작성 시 일정 길이 초과된 투두는 레이아웃 깨짐 발생, 나중에 수정해야 할듯

###240516 오후 17:37
f_home.dart
-todo위젯 박스 분리
+추가수정사항
pubspec.yaml -카메라 패키지 추가
Android (AndroidManifest.xml), iOS (Info.plist) -각 파일에 카메라 설정 추가
dto_cameraimagedetection.dart -카메라위젯으로 이미지 검출(현: 10초마다 캡쳐 -> 30초마다 리셋)
cameraimage.dart -검출한 이미지 저장공간
w_camera -카메라 위젯
f_camera -타이머 페이지에서 버튼으로 연결되는 카메라 페이지


###수정사항
필요없는 위젯, 파일 제거
다크모드제거, 색, 글씨체
홈화면 위젯 or 이미지추가
타이머페이지
캘린더페이지

###
타이머 페이지 오류제가
app바 통일

###240519 02:57
appBar 통일 완료
reset-restrart 수정