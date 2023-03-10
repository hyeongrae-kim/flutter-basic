import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: getNumber(),
          builder: (context, snapshot) {
           /*if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }*/
            if(snapshot.hasData){
              //데이터가 있을때 위젯 렌더링
            }
            if(snapshot.hasError){
              // 에러가 났을때 위젯 렌더링
            }
            // 로딩중일때 위젯 렌더링
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'FutureBuilder',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  'ConState : ${snapshot.connectionState}',
                  style: textStyle,
                ),
                Text(
                  'Data : ${snapshot.data}',
                  style: textStyle,
                ),
                Text(
                  'Error : ${snapshot.error}',
                  style: textStyle,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(){};
                  },
                  child: Text('setState'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));

    final random = Random();

    throw Exception('Error Make.');

    return random.nextInt(100);
  }

  Stream<int> streamNumbers() async* {
    for(int i=0; i<10; i++){
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }
}
