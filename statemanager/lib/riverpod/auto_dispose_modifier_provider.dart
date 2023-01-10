import 'package:flutter_riverpod/flutter_riverpod.dart';

// 캐싱을 안하고 자동 삭제를 해서 화면을 나갔다 들어오면 다시 실행함. 그래서 auto dispose
// 필요가 없을 때 자동 삭제, 필요하면 다시 불러옴
final autoDisposeModifierProvider =
    FutureProvider.autoDispose<List<int>>((ref) async {
  await Future.delayed(Duration(seconds: 2));

  return [1, 2, 3, 4, 5];
});
