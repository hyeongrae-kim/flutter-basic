import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/user/provider/auth_provider.dart';
import 'package:actual/user/provider/user_me_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.ref,
    required this.storage,
  });

  // 인터셉터는 아래 3가지 경우에 중간에 가로채서 또다른 무언가로 바꿀 수 있음
  // 1) 요청 보낼때 (보내기 전에 인터셉트함)
  // 요청이 보내질때마다 만약에 header에 accessToken: true라는 값이 있다면 실제 토큰을 가져와서 authorization: bearer $token으로 변경함
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답 받을때
  // 인터럽트를 등록했기 때문에 정상적인 요청/응답에서 인터럽트내의 요청/응답이 모두 결국 실행됨
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을때(status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급 되면
    // 다시 새로운 토큰으로 요청을 함

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    // refreshToken이 없을 때 에러를 던짐
    if (refreshToken == null) {
      // handler.reject -> 에러반환
      // handler.resolve -> 에러x
      return handler.reject(err);
    }

    final isStatus401 =
        err.response?.statusCode == 401; // 401 -> 토큰이 잘못됐다. 서버의 특정 정의
    final isPathRefresh =
        err.requestOptions.path == '/auth/token'; // 토큰을 발급받을려던 오청이였나?

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        // error를 발생시킨 요청에 옵션만 바꿔서 다시 재전송. 재전송은 fetch
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );
        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioError catch (e) {
        // refreshToken마저 만료되었을 땐 로그아웃해야함
        // 단순히 아래와 같이 추가하면 해결하지 못함
        // circular dependency error 초래
        // A, B
        // A -> B의 친구
        // B -> A의 친구
        // 사람 : A는 B의 친구구나
        // 기계 : A -> B -> A -> B -> A..... 와 같이 인식함
        // => Circular dependency error

        // ref.read(userMeProvider.notifier).logout();

        // userMeProvider안에 logout을 사용할려는데, 안에 authprepository, usermerepository가 있음
        // authrepository, usermerepository가 dio를 사용하고 필요로함
        // 그런데 dio는 Request 과정에서 error가 나서 intercept된 상태로 멈춰있는 상태.
        // => uMP -> dio -> uMP -> dio -> uMP -> .... 와 같이 에러가 됨

        // read -> 함수가 실행되는 순간에만 provider를 불러옴. 실제로 전체 클래스의 디펜던시는 아님
        // 함수를 불러오는 순간에만 이 클래스를 알고있으면됨
        // 그런데 직접 inject를 하는 경우엔 서로의 값을 build time에 넣어줘야함.
        // 동시에 넣어줘야 되는데 동시에 서로를 참조해서 안됨


        // 따라서 아래와 같이 우회를 할 필요가 있다.
        ref.read(authProvider.notifier).logout();


        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
