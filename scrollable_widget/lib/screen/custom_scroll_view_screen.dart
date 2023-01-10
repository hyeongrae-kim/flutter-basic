import 'package:flutter/material.dart';
import 'package:scrollable_widget/const/colors.dart';

class _SliverFixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SliverFixedHeaderDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  // 최대 높이
  double get maxExtent => maxHeight;

  @override
  // 최소 높이
  double get minExtent => minHeight;

  @override
  // covariant - 상속된 클래스도 사용가능
  // oldDelegate - build가 실행이 됐을때 이전 delegate
  // this - 새로운 delegate
  // shouldRebuild - 새로 build를 해야할지 말지 결정
  // false - build안함 true - build다시함
  bool shouldRebuild(_SliverFixedHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight || oldDelegate.child != child;
  }
}

class CustomScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  CustomScrollViewScreen({Key? key}) : super(key: key);

  // 스크롤 가능한 위젯은 Expanded안에 안넣으면 에러가 뜸!
  // 리스트 뷰 - 리스트로 무한한 위젯 넣을 수 있으므로, 이 높이는 이론적으로 무한
  // 따라서 Expanded를 넣어서 컬럼의 최대 높이만큼만 써라고 지정해 주어야함
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // sliver에 넣을 수 있는 위젯은 특정되어있음.
        slivers: [
          renderSliverAppbar(),
          renderHeader(),
          renderBuilderSliverList(),
          renderHeader(),
          renderSliverGridBuilder(),
          renderBuilderSliverList(),
        ],
      ),
    );
  }

  SliverPersistentHeader renderHeader(){
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverFixedHeaderDelegate(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              '예아',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        minHeight: 75,
        maxHeight: 150,
      ),
    );
  }

  SliverAppBar renderSliverAppbar() {
    return SliverAppBar(
      // 밑으로 스크롤 하면 앱바가 사라졌다가, 위로 올리면 다시 나타남
      // 스크롤 했을때 리스트의 중간에도 Appbar가 내려오게 함
      floating: true,
      // 스크롤을 내리든 올리든 앱바가 완전히 고정됨
      pinned: false,
      // 자석 효과
      // floating이 true일 경우에만 할 수 있음
      snap: true,
      // 위젯의 제일 상단보다 더 땡기면 scaffold색상인 흰 배경이 나옴
      // 이 남는 경우를 appBar 색상이 차지하게 함
      stretch: true,
      // appbar의 최소, 최대 높이
      expandedHeight: 200,
      collapsedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'asset/img/image_1.jpeg',
          fit: BoxFit.cover,
        ),
        title: Text('FlexibleSpace'),
      ),
      title: Text('CustomScrollViewScreen'),
    );
  }

  // ListView 기본 생성자와 유사함
  SliverList renderChildSliverList() {
    return SliverList(
      // delegate - 메모리에 위젯을 100개 모두 띄울건지, 보이는 것만 띄울건지 선택
      // SliverChildListDelegate -> 모든 위젯들을 한번에 메모리에 다 그림. 기본형태의 리스트 뷰
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) =>
              renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
        )
            .toList(),
      ),
    );
  }

  // ListView.builder 생성자와 유사함
  SliverList renderBuilderSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index,
          );
        },
        childCount: 100,
      ),
    );
  }

  // GridView.count 유사함
  SliverGrid renderChildSliverGrid() {
    return SliverGrid(
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) =>
              renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
        )
            .toList(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  // GridView.builder와 유사함
  SliverGrid renderSliverGridBuilder() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index,
          );
        },
        childCount: 100,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
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
