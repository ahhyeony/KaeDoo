import 'package:mysql_client/mysql_client.dart';

Future<MySQLConnection> dbConnector() async {
  // 연결 시도 시작
  print("Connecting to mysql server...");

  // mySQL 설정 -- 연결 중
  final conn = await MySQLConnection.createConnection(
      //host: "localhost" , //android 10.0.2.2
      host: '172.30.1.9', // 어차피 무조건 어딜가나 바꿔야 하는 부분
      port: 3306,

      // 필요시 주석처리 해제해서 사용하기
      // userName: 'kaedoo',
      // password: '12341234',
      userName: 'ah',
      password: '0227',

      databaseName: 'kaedoo'
  );

  // 연결 완료
  await conn.connect();
  print("Connected!");

  return conn;
}



