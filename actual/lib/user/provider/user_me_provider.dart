import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/repository/auth_repository.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userMeProvider = StateNotifierProvider<UserMeStateNotifier, UserModelBase?>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final userMeRepository = ref.watch(userMeRepositoryProvider);
    final storage = ref.watch(secureStorageProvider);
    return UserMeStateNotifier(
      authRepository: authRepository,
      repository: userMeRepository,
      storage: storage,
    );
  },
);

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    // 내 정보 가져오기
    // 일단 클래스가 인스턴스화 되면 토큰 기반으로 어떤 유저인지 확인
    getMe();
  }

  Future<void> getMe() async {
    // repository의 getMe함수를 통해 유저 확인하기 전에, 애초에 토큰이 없다면 요청을 보내지 않아도 된다. 그래서 불러옴
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      // logoff된 상태임을 알려주기 위해 state를 null로 지정
      state = null;
      return;
    }

    final resp = await repository.getMe();

    // 상태에 바로 UserModel상태 저장
    state = resp;
  }

  // 로그인상태 또는 에러상태 반환
  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final resp = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      // 로그인을 한 다음, 해당 토큰에 해당되는 사용자의 정보를 저장해놓기 위해 getMe 실행
      // 상태에 userModel을 넣지 않으면 로그인한 상태라고 알 수 없음
      final userResp = await repository.getMe();

      state = userResp;

      return userResp;
    } catch (e) {
      // 실제 서비스 할 때는 아이디가 틀렸는지, 비밀번호가 틀렸는지 확실하게 반환
      state = UserModelError(message: '로그인에 실패했습니다.');

      // 함수의 반환형과 맞춰주기 위해 Future.value사용
      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    // Future 동시에 실행
    // 삭제 두개 동시에 실행하고 둘 다 끝날때 까지 await, 아래 코드보다 속도가 조금 더 향상이 됨
    await Future.wait([
      storage.delete(key: REFRESH_TOKEN_KEY),
      storage.delete(key: ACCESS_TOKEN_KEY),
    ]);

    // await storage.delete(key: REFRESH_TOKEN_KEY);
    // await storage.delete(key: ACCESS_TOKEN_KEY);
  }
}
