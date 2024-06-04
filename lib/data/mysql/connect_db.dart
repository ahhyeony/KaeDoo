import 'package:mysql_client/mysql_client.dart';

Future<MySQLConnection> dbConnector() async {
  // 연결 시도 시작
  print("Connecting to mysql server...");

  // mySQL 설정 -- 연결 중
  final conn = await MySQLConnection.createConnection(
      //host: "localhost" , //android 10.0.2.2
      host: '10.30.76.130',   //10.30.132.37
      port: 3306,
      userName: 'kaedoo',      //ah
      password: '12341234',      //0227
      databaseName: 'kaedoo'
  );

  // 연결 완료
  await conn.connect();
  print("Connected!");

  return conn;
}



