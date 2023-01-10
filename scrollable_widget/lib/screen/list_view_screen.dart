import 'package:flutter/material.dart';
import 'package:scrollable_widget/const/colors.dart';
import 'package:scrollable_widget/layout/main_layout.dart';

class ListViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  ListViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ListViewScreen',
      body: renderSeparated(),
    );
  }

  // 1. 기본 - 모두 한번에 그림
  // 그냥 리스트뷰를 사용하여 위젯 100개를 로딩하면, 100개 모두 메모리에 올라오게 됨
  Widget renderDefault() {
    return ListView(
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

  // 2. 보이는 것만 그림
  // 빌더를 사용하여 위젯 100개를 로딩하면, 필요한 위젯 일부만 메모리에 올라오고 알아서 관리가 됨.
  Widget renderBuilder() {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );
  }

  // 3. 2 + 중간중간 추가할 위젯 넣음
  // ListView.builder와 같은데, separatorBuilder 추가 이는 itemBuilder 사이사이에 widget 추가해주는 기능.
  // 특정 개수의 위젯마다 특정한 위젯을 띄우는데 용이
  Widget renderSeparated(){
    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
      separatorBuilder: (context, index) {
        index += 1;
        // 5개의 item마다 배너 보여주기
        if(index % 5 == 0){
          return renderContainer(
            color: Colors.black,
            index: index,
            height: 100,
          );
        }
        return Container();
      },
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
