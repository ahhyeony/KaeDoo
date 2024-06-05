A new Flutter project.

## Object-File name
- Widget-w_{name}.dart : 위젯
- Screen-s_{name}.dart : 전체 디바이스를 덮는 화면
- Fragment-f_{name}.dart : Screen 내부에 일부로 존재하는 콘 화면 Widget
- Dialog-d_{name}.dart : Dialog 혹은 Bottom Sheet
- Value Object-vo_{name}.dart : UI에서 사용하는 객체
- Data Transfer Object-dto_{name}.dart : 통신이나 데이터 저장에 사용되는 객체
- 나머지-소문자,숫자,_조합

---

### 240515 05:33
- 스플래시 스크린 : 적용 완료
- 투두 리스트(홈) : 입력까지 가능하나, 저장이 안 됨 (assertion failed)
- 타이머 : start 누르고 나면 stop/restart로 바뀌는 거 보고 기존 restart와 혼동이 있을 것 같아 기존의 restart -> reset 으로 변경

### 240515 18:46
새로추가한 파일
- w_calendar.dart -캘린더위젯
- w_timedata.dart -캘린더하단에 시간통계위젯
- w_wtimedata.dart -주간 공부시간 통계 위젯. 목록탭으로 일간/주간/월간 등등 하려고 했는데 컴터 다운당해서 일단 따로 파서 구현함
수정한 파일
- pub spec.yaml. -> table_calendar, pie_chart 추가 -캘린더, 그래프
- dto_timestorage.dart, w_timerecord.dart, tab_navigator.dart -이것저것 변수 조정하면서 만지다 일단 실행 가능하게 수정함
- w_timerdata.dart -일간 공부시간 통계 위젯
- f_calendar.dart, f_timer.dart -디자인하려고 했는데 먼가 얽힘. 다시봐야할듯.

### 240516 11:47
- 의존성 추가: percent_indicator: ^4.0.1 (퍼센트를 바로 나타내는 라이브러리)
- lint 끄기
- 투두 : 작업 추가, 수정, 삭제, 진척도 구현 완료
- 버그 : 투두 작성 시 일정 길이 초과된 투두는 레이아웃 깨짐 발생, 나중에 수정해야 할듯

### 240516 17:37
- f_home.dart -todo위젯 박스 분리
추가수정사항
- pubspec.yaml -카메라 패키지 추가
- Android (AndroidManifest.xml), iOS (Info.plist) -각 파일에 카메라 설정 추가
- dto_cameraimagedetection.dart -카메라위젯으로 이미지 검출(현: 10초마다 캡쳐 -> 30초마다 리셋)
- cameraimage.dart -검출한 이미지 저장공간
- w_camera -카메라 위젯
- f_camera -타이머 페이지에서 버튼으로 연결되는 카메라 페이지


### 수정사항
- 필요없는 위젯, 파일 제거
- 다크모드제거, 색, 글씨체
- 홈화면 위젯 or 이미지추가
- 타이머페이지
- 캘린더페이지
- 타이머 페이지 오류제거
- app바 통일

### 240519 02:57
- appBar 통일 완료
- reset-restrart 수정

### 240526 04:27
- mySQL DB 연동
- 로그인/로그아웃/회원가입 기능 구현

### 240603 16:36
- f_camera.dart, dto_cameraimagedetection.dart, w_face_detector.dart 수정
- Face detection 및 Eye detection 구현
- UI 내에서 감지된 얼굴 수와 양쪽 눈의 Open/Close 여부 확인 가능
- 회원가입 UI 통일
- 로그인, 회원가입 페이지의 커서 컬러 변경
- 회원가입 페이지에서...
1 계정 생성 눌러서 닫기 버튼을 눌렀을 때 로그인 화면으로 돌아가도록 구현
2 아이디, 비밀번호, 비밀번호확인 중 하나라도 입력하지 않은 경우 재입력 알림이 뜨도록 구현

### 240603 17:20
- home -화면 날짜 조정 가능
- home화면에서 w_progress_bar ,w_task_list 위젯 추가로 기능 분리
- w_timer - Reset 버튼 삭제 및 Record 시 타이머 초기
- w_timerecord - 삭제 시 안내창 출력

### 240604 01:00
- w_timedata -통계데이터 그래프 수정

### 240604 15:25
- w_face_detector.dart, dto_cameraimagedetection.dart 수정
- 졸음 감지 구현
- 10프레임마다 캡쳐 -> 1초마다 캡쳐로 변경
- 이미지 잘 전달 받아 감지 얼굴 수, 눈 개폐 여부 확인 완료

### 240604 16:40
- dto_ctimestorage, w_ctimer, w_ctimerecord 추가
- f_camera 연동

### 240605 23:39
- dto_ctimestorage.dart, w_face_detector.dart 수정
- w_face_painter.dart는 필요없어서 삭제함
- 졸음 감지 후 시간 차감 기능 구현
- 10초 동안 졸음 판단 후...
    졸음인 경우 다시 눈을 뜰 때까지 시간을 누적(10+a)하여 총 시간에서 제거
    졸음이 아닌 경우 졸음 판단에 소요된 시간 또한 공부 시간으로 인정
- 타이머가 켜져있고 사람 얼굴이 감지되고 있는 상황에만 졸음 감지 기능이 작동하도록 수정함
- 졸음 시간 차감시 레코드에 바로 반영됨 (42초 중 30초 졸았으면 12초로 레코드)

### 240606 24:20
- w_timedata = 일간통계위젯
- 기존 : w_timedata.dart에서 dto_timestorage.dart에서 가져온 값 저장하는 로직
- 수정 : dto_ctimestorage.dart에서 가져온 값도 저장하는 로직으로 수정
- 결론 : timestorage, ctimestorage 클래스를 f_calendar.dart에서 구현해 w_timedata로 값 불러오고 더해서 출력
- 사실 잘 모름, 대충 굴러감