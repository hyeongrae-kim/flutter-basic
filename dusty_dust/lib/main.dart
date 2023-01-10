import 'package:dusty_dust/screen/home_screen.dart';
import 'package:dusty_dust/screen/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/stat_model.dart';

const testBox = 'test';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<StatModel>(StatModelAdapter());
  Hive.registerAdapter<ItemCode>(ItemCodeAdapter());

  // box안에 물건을 넣는거처럼 데이터를 마음대로 집어넣음.
  // 열어두면 항상 마음대로 사용가능,
  // box - 하드드라이브로부터 메모리로 데이터를 올려서 앱에서 사용한는 뜻
  await Hive.openBox(testBox);

  for(ItemCode itemCode in ItemCode.values){
    await Hive.openBox<StatModel>(itemCode.name);
  }



  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunflower'
      ),
      home: HomeScreen(),
    ),
  );
}
