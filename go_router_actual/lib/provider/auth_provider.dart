import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_actual/model/user_model.dart';
import 'package:go_router_actual/screen/1_screen.dart';
import 'package:go_router_actual/screen/2_screen.dart';
import 'package:go_router_actual/screen/3_screen.dart';
import 'package:go_router_actual/screen/error_screen.dart';
import 'package:go_router_actual/screen/home_screen.dart';
import 'package:go_router_actual/screen/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStateProvider = AuthNotifier(
    ref: ref,
  );

  return GoRouter(
    initialLocation: '/login',
    // error가 생길 때 반환되는 화면
    errorBuilder: (context, state) {
      return ErrorScreen(error: state.error.toString());
    },
    // redirect
    // GoRouterState는 함수 안에 자동으로 넣어줌
    redirect: authStateProvider._redirectLogic,
    // refresh -> redirect 조건. changeNotifier 또는 Stream을 무조건 사용해야함
    // refreshListenable에 들어간 authStateProvider의 상태가 바뀔 때 마다 위의 redirect를 재실행하게됨
    // (라우트가 굳이 이동 안하더라도(페이지이동이 없더라도)) 예를들어 로그인 토큰이 만료된 상황 같은
    // 이게 없으면 페이지 이동할 때마다만(Navigation할때만) redirect 하게됨.
    refreshListenable: authStateProvider,

    // _private 이더라도 같은파일 내면 사용가능
    routes: authStateProvider._routes,
  );
});

// ChangeNotifier -> 일반 Provider처럼 생각하고 사용
// provider를 listen, watch 할려면 최소 ref 필요
// ChangeNotifier은 ref가 없다.
// 그래서 많이 사용하는 패턴 중 하나는 ChangeNotifier에 ref를 전달
class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({
    required this.ref,
  }) {
    ref.listen<UserModel?>(
      userProvider,
      // previous, next -> userProvider 가 바라보는 UserModel의 상태(로그인 상태)
      (previous, next) {
        // 상태가 변경이 되었다는 것을 알려주기
        // Change Notifier에선 notifyListenr()가 실행되면 ChangeNotifier를 바라보는 모든 위젯이 rebuild됨
        // 그래서 실행하는 것 만으로 값이 바꼈다는것을 알려주게된다.
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  // GoRouterState -> routing에대한 모든 정보 받을 수 있음
  String? _redirectLogic(GoRouterState state) {
    // user모델 인스턴스 또는 null이 들어오게됨
    final user = ref.read(userProvider);

    // 로그인을 하려는 상태인지
    // state.location(현재 페이지 위치)가 로그인을 하는 페이지일때
    final loggingIn = state.location == '/login';

    // 유저 정보가 없다 - 로그인한 상태가 아니다
    //
    // 유저 정보가 없고 로그인하려는 중이 아니라면 -> 로그인 페이지로 이동한다.
    // redirect logic은 첫 고라우터의 redirect속성에 들어가게 되고, 이는 네비게이션 할 때 마다 실행이 된다.(페이지 이동할 때 마다)
    // redirectLogic이 null을 return하면 기존에 이동하려는 페이지로 그대로 보낸다.
    // 다른 것을 반환하면 강제로 페이지를 이동하게 된다.
    if(user==null){
      return loggingIn ? null : '/login';
    }

    // 유저 정보가 있는데 로그인 페이지라면 홈으로 이동해야한다.
    // user정보가 있는지 없는지는 위에서 검사 했으므로 로그인페이지인지만 확인하면 된다.
    if(loggingIn){
      return '/';
    }

    // 나머지 상태는 원래 가려는 곳 보내줌
    return null;
  }

  // routes는 tree형태 생각하면 된다
  List<GoRoute> get _routes => [
        GoRoute(
          path: '/',
          builder: (_, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: 'one',
              builder: (_, state) => OneScreen(),
              routes: [
                GoRoute(
                  path: 'two',
                  builder: (_, state) => TwoScreen(),
                  routes: [
                    GoRoute(
                      path: 'three',
                      name: ThreeScreen.routeName, // name은 unique 해야함.
                      builder: (_, state) => ThreeScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/login',
          builder: (_, state) => LoginScreen(),
        ),
      ];
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(),
);

// login 한 상태면 UserModel 인스턴스 상태로 넣어주기
// login 하지 않았으면 null 상태
class UserStateNotifier extends StateNotifier<UserModel?> {
  // 처음에는 로그인을 안했을거니까 null
  UserStateNotifier() : super(null);

  // login 함수
  login({
    required String name,
  }) {
    state = UserModel(name: name);
  }

  // logout 함수
  logout() {
    state = null;
  }
}
