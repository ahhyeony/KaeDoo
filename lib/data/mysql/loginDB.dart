import 'package:kaedoo/data/mysql/connect_db.dart';
import 'package:mysql_client/mysql_client.dart';

// 계정 생성
Future<void> insertMember(String userId, String password) async {
  final conn = await dbConnector();

  // DB에 유저 정보 추가
  try {
    await conn.execute(
        "INSERT INTO users (id, password) VALUES (:id, :password)",
        {"id": userId, "password": password});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

// 로그인
Future<String?> login(String userId, String password) async {
  final conn = await dbConnector();

  IResultSet? result; // 쿼리 수행 결과 저장 변수

  // DB에 해당 유저의 아이디와 비밀번호를 확인하여 users 테이블에 있는지 확인
  try {
    result = await conn.execute(
        "SELECT id FROM users WHERE id = :id and password = :password",
        {"id": userId, "password": password});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        // 유저 정보가 존재하면 유저의 index 값 반환
        return row.colAt(0);
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}

// 유저ID 중복확인
Future<String?> confirmIdCheck(String userId) async {
  final conn = await dbConnector();

  IResultSet? result; // 쿼리 수행 결과 저장 변수

  // ID 중복 확인
  try {
    // 아이디가 중복이면 1 값 반환, 중복이 아니면 0 값 반환
    result = await conn.execute(
        "SELECT IFNULL((SELECT id FROM users WHERE id=:id), 0) as idCheck",
        {"id": userId});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        return row.colAt(0);
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}



