import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler/database/drift_database.dart';

const DEFAULT_COLORS = [
  // 빨강
  'F44336',
  // 주황
  'FF9800',
  // 노랑
  'FFEB3B',
  // 초록
  'FCAF50',
  // 파랑
  '2196F3',
  // 남색
  '3F51B5',
  // 보라
  '9C27B0',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // fluter framework 준비되어있는지 확인.
  // runApp을 하게되면 위의 내용이 자동 실행되는데, runApp이전 할 일을 넣어줬으므로 수동세팅 해줘야함.

  await initializeDateFormatting();  // intl package 안에 모든 data 사용하기 위함

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);  // 어디에서든 database를 사용하기 위해 Getit pkg활용하여 만듬.

  final colors = await database.getCategoryColors();  // databae안에 색깔들을 다 가져옴.
  if(colors.isEmpty){  // database안에 색깔이 없으면 색깔 저장
    for(String hexCode in DEFAULT_COLORS){
      await database.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        ),
      );
    }
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(),
    ),
  );
}
