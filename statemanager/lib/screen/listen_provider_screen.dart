import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanager/layout/default_layout.dart';
import 'package:statemanager/riverpod/listen_provider.dart';

class ListenProviderScreen extends ConsumerStatefulWidget {
  const ListenProviderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListenProviderScreen> createState() =>
      _ListenProviderScreenState();
}

class _ListenProviderScreenState extends ConsumerState<ListenProviderScreen>
    with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(
      length: 10,
      vsync: this,
      initialIndex: ref.read(listenProvider),
    );
  }

  @override
  // stful쓰면 context도 state안에 어디서든 global하게 적용되기 때문에 두번째 파라미터가 필요없음
  // 여기 클래스 안에 ref 기본 제공해서 this.ref로 ref 사용 가능
  Widget build(BuildContext context) {
    // riverpod의 listen은 dispose할 필요 없음
    ref.listen<int>(listenProvider, (previous, next) {
      if(previous!=next){
        controller.animateTo(next);
      }
    });
    
    return DefaultLayout(
      title: 'ListenProviderScreen',
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: List.generate(
          10,
          (index) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(index.toString()),
              ElevatedButton(
                onPressed: () {
                  ref.read(listenProvider.notifier).update((state) => state == 10 ? 10 : state+1);
                },
                child: Text(
                  '다음',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(listenProvider.notifier).update((state) => state == 0 ? 0 : state-1);
                },
                child: Text(
                  '뒤로',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
