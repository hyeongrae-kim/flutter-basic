import 'package:flutter/material.dart';
import 'package:scrollable_widget/layout/main_layout.dart';

import '../const/colors.dart';

class SingleChildScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(
    100,
    (index) => index,
  );

  SingleChildScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'SingleChildScrollView',
      body: renderPerformance(),
    );
  }

  // 1. 기본 렌더링 법 -> SingleChildScrollView
  // 만약에 child안의 위젯의 크기가 화면크기를 안 넘어서면 기본은 스크롤이 안되는 형태.
  // 위젯의 크기가 화면을 넘어가면 스크롤이 됨.
  Widget renderSimple() {
    return SingleChildScrollView(
      child: Column(
        children: rainbowColors
            .map(
              (e) => renderContainer(
                color: e,
              ),
            )
            .toList(),
      ),
    );
  }

  // 2. physics 활용, 화면 넘어가지 않아도 스크롤 가능하게 만듬
  Widget renderAlwaysScroll() {
    return SingleChildScrollView(
      // physics : scroll이 어떻게 작용하는지 정하는 것
      // 기본값 - NeverScrollableScrollPhysics - 스크롤 안됨
      // AlwaysScrollableScrollPhysics -> 위젯이 화면 안넘어가도 스크롤이 되도록 함.
      // BouncingScrollPhysics -> 안드로이드는 제일 상단 위젯을 밑으로 땡기지 못함. ios는 기본이 튕김.
      // ClampingScrollPhysics -> 안드로이드 스타일. 제일 상단 위젯을 밑으로 땡기지 못하게
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(color: Colors.black),
        ],
      ),
    );
  }

  // 3. clip 활용, 스크롤할때 위젯이 잘리지 않게 하기
  Widget renderClip() {
    return SingleChildScrollView(
      // clipBehavior - 잘렸을때 어떻게 행동할것인가?
      // Clip.antiAlias, Clip.antiAliasWithSaveLayer, Clip.hardEdge -> 스크롤할때 위젯이 잘림
      // Clip.none -> 스크롤할때 위젯이 잘리지 않음
      clipBehavior: Clip.none,
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(color: Colors.black),
        ],
      ),
    );
  }

  // 4 SingleChildScrollView 퍼포먼스
  // SingleChildScrollView는 100개의 위젯이 있으면, 화면에 100개가 다 안나오더라도 한번에 불러옴.
  // 위와같은 이유로 퍼포먼스가 떨어지는 단점이 존재.
  Widget renderPerformance(){
    return SingleChildScrollView(
      child: Column(
        children: numbers
            .map(
              (e) => renderContainer(
            color: rainbowColors[e % rainbowColors.length],
            index: e,
          ),
        )
            .toList(),
      ),
    );
  }

  Widget renderContainer({
    required Color color,
    int? index,
  }) {
    if(index != null){
      print(index);
    }
    return Container(
      height: 300,
      color: color,
    );
  }
}
