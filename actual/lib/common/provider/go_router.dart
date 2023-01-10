import 'package:actual/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref){
  // watch - 값이 변경될때마다 다시 빌드
  // read - 한번만 읽고 값이 변경되도 다시 빌드하지 않음
  // goRouter instance는 항상 똑같은 인스턴스만 변경해야 하므로 read를 사용해야한다.
  final provider = ref.read(authProvider);

  return GoRouter(
    routes: provider.routes,
    initialLocation: '/splash',
    refreshListenable: provider,
    redirect: provider.redirectLogic,
  );
});