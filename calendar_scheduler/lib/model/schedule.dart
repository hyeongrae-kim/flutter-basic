import 'package:drift/drift.dart';

// drift를 활용하여 dart->SQL
class Schedules extends Table {
  // ID, CONTENT, DATE, STARTTIME, ENDTIME, COLORID, CREATEAT

  // PRIMARY KEY
  IntColumn get id => integer().autoIncrement()();  // integer()의 반환값이 함수라 ()를 한번더 넣어 반환값 실행
  // autoIncrement : row insert할 때 id는 자동으로 배정해줘서 따로 추가할필요 없게함.

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 끝 시간
  IntColumn get endTime => integer()();

  // Category Color Table ID
  IntColumn get colorId => integer()();

  // 생성 날짜 - CreateAt = 항상 DateTime.now() 값을 같게됨
  DateTimeColumn get createdAt => dateTime().clientDefault(  // clientDefault - 함수 하나 받을수 있음.(return)
      () => DateTime.now(),  // default는 값을 안넣어줄땐 이게 실행되고, 우리가 직접 임의값을 넣어 줄 수도 있음.
  )();
}