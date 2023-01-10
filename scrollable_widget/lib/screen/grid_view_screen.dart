import 'package:flutter/material.dart';
import 'package:scrollable_widget/const/colors.dart';
import 'package:scrollable_widget/layout/main_layout.dart';

class GridViewScreen extends StatelessWidget {
  List<int> numbers = List.generate(100, (index) => index);

  GridViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'GridViewScreen',
      body: renderMaxExtent(),
    );
  }

  // 1. GridView.count -> 위젯의 개수를 모두 한번에 메모리에 그림.
  Widget renderCount() {
    return GridView.count(
      // 가로로 위젯을 몇개를 넣을것인가?
      crossAxisCount: 2,
      // 가로 위젯의 간격을 얼마로 설정할것인가?
      crossAxisSpacing: 12.0,
      // 세로로 위젯의 간격을 얼마로 줄것인가?
      mainAxisSpacing: 12.0,
      children: numbers
          .map(
            (e) => renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            ),
          )
          .toList(),
    );
  }

  // 2. 메모리에 화면에 보이는 일부 위젯만 그림.(보이는 것만 그림)
  Widget renderBuilderCrossAxisCount(){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 가로로 위젯을 몇개를 배치할까?
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
      itemCount: 100,
    );
  }

  // 3. 최대 사이즈
  Widget renderMaxExtent(){
    return GridView.builder(
      // GridView안의 위젯들의 개개인 최대길이
      // 길이를 작게하면 한 row에 여러개의 위젯이 들어올 수도 있음
      // 최대가 max 값이면서, 최대한 많은 위젯을 한줄에 넣어버림
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
      ),
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
      itemCount: 100,
    );
  }

  Widget renderContainer({
    required Color color,
    required int index,
    double? height,
  }) {
    print(index);
    return Container(
      height: height ?? 300,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}
