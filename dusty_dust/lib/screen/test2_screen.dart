import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';

class Test2Screen extends StatelessWidget {
  const Test2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test2Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>(
            valueListenable: Hive.box(testBox).listenable(),  // hive의 특정 값 변경마다 listen해라
            builder: (context, box, widget){
              return Column(
                children: box.values.map((e) => Text(e)).toList(),
              );
            },
          ),
        ],
      ),
    );;
  }
}
