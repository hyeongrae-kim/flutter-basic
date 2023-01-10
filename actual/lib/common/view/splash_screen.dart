import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../const/colors.dart';

// class SplashScreen extends ConsumerStatefulWidget {
//   static String get routeName => 'splash';
//
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

class SplashScreen extends ConsumerWidget {
  // @override
  // void initState() {
  //   super.initState();
  //   // deleteToken();
  //   checkToken();
  // }
  //
  // void deleteToken() async{
  //   final storage = ref.read(secureStorageProvider);
  //
  //   await storage.deleteAll();
  // }
  //
  // void checkToken() async {
  //   final storage = ref.read(secureStorageProvider);
  //
  //   final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
  //   final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  //
  //   final dio = Dio();
  //
  //   try{
  //     final resp = await dio.post(
  //       'http://$ip/auth/token',
  //       options: Options(
  //         headers: {
  //           'authorization': 'Bearer $refreshToken',
  //         },
  //       ),
  //     );
  //
  //     await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);
  //
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (_) => RootTab(),
  //       ),
  //           (route) => false,
  //     );
  //   }catch(e){
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (_) => LoginScreen(),
  //       ),
  //           (route) => false,
  //     );
  //   }
  // }
  static String get routeName => 'splash';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
