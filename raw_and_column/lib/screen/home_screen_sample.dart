import 'package:flutter/material.dart';


class HomeScreen_ extends StatelessWidget {
  const HomeScreen_({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          color: Colors.black,
          // height: MediaQuery.of(context).size.height, //MediaQuerty.of(context).size = 사용자 기기 사이즈 가져옴
          child: Column(
            // MainAxisAlignment - 주축 정렬
            // start - 시작
            // end - 끝
            // center - 가운데
            // spaceBetween - 위젯 사이 간격 동일하게 띄워서 배치
            // spaceEvenly - 위젯을 같은 간격으로 배치하는데, 끝과 끝에 빈칸으로 시작
            // spaceAround - spaceEvenly + 양 끝 간격은 간격 사이즈의 절반
            mainAxisAlignment: MainAxisAlignment.start,
            // CrossAxisAlignment - 반대축 정렬
            // row일때 세로, coloumn일때 가로 정렬
            // start - 시작
            // end - 끝
            // center - 가운데(기본값)
            // stretch - 최대한으로 늘린다.
            crossAxisAlignment: CrossAxisAlignment.start,
            // MainAxisSize - 주축 크기
            // max - 최대
            // min - 최소
            mainAxisSize: MainAxisSize.max,
            children: [
              // Expanded / Flexible - Row, Column Widget의 children에만 사용가능
              // Expanded - 최대한으로 남아있는 사이즈 모두 차지
              // flex - 공간을 나눠먹는 비율
              // Flexible - 지정 공간만큼 차지하고, 남은 공간은 버림
              Flexible(
                child: Container(
                  color: Colors.red,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.orange,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.yellow,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}