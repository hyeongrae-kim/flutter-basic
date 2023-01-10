// import - private 값들은 불러올 수 없다.
import 'dart:io';

import 'package:calendar_scheduler/model/category_color.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:calendar_scheduler/model/schedule_with_color.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// part - private 값까지 불러올 수 있다.
part 'drift_database.g.dart'; // (현재파일).g.dart - generated(자동으로 생성됨) 특정 커맨드 실행해서 자동으로 생성되도록 할 예정
// terminal - flutter pub run build_runner build를 하게되면 생성됨.

// @~ - decorator
@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
// 실제 데이터베이스 형성할 클래스
// (현재파일).g.dart가 생성될 때 자동으로 생성된 파일 안에 _$LocalDatabase 생성함. 그 class를 상속하면 database관한 모든 기능 사용가능
class LocalDatabase extends _$LocalDatabase {
  // _$(same name with class) -> drift가 나중에 drift_database.g.dart안에 만들어 주는 클래스
  LocalDatabase() : super(_openConnection());

  //Query
  //Schedule insert. id값 return 받음
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  //Category color insert. id값 return 받음
  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  //Category color select.
  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  //Schedule update. (수정)
  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  // .go() -> 테이블의 모든 row 삭제
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  // watch => stream 사용. 값이 업데이트 될때마다 지속적으로 업데이트 된 값을 받게함.
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);
    query.where(schedules.date.equals(date));
    query.orderBy([
      // asc -> ascending 오름차순, desc -> descending 내림차순
      OrderingTerm.asc(schedules.startTime),
    ]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithColor(
                  schedule: row.readTable(schedules),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );

    // .. -> 뒤에 함수는 실행하는데, 함수 실행 결과값이 리턴되지 않고 함수실행한 대상이 리턴됨.
    // return (select(schedules)..where((tbl)=>tbl.date.equals(date))).watch();
  }

  @override
  int get schemaVersion =>
      1; // table상태 버전 = schemaVersion. 테이블 구조가 바뀔때마다 schemaVersion을 올려줘야함
// version upgrade 할 때 어떤 작업들을 해야하는지도 추후에는 코드를 작성해줘야함.
}

// 연결 , 어느 위치에 저장할지 명시 해줘야함
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder =
        await getApplicationDocumentsDirectory(); // path_provider pkg 기능. 앱 데이터 저장가능 위치 가져옴
    final file = File(p.join(dbFolder.path,
        'db.sqlite')); // dbFolder 경로에 db.sqlite 파일 생성해서 그걸 file 변수로 가리킴
    // 추후 db.sqlite안에 우리가 저장할 정보(column, row들)를 넣게됨.
    return NativeDatabase(file);
  });
}
