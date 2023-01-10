import 'package:flutter/material.dart';
import 'package:navigation/screen/home_screen.dart';
import 'package:navigation/screen/route_one_screen.dart';
import 'package:navigation/screen/route_three_screen.dart';
import 'package:navigation/screen/route_two_screen.dart';

const HOME_ROUTE = '/';

void main() {
  runApp(
    MaterialApp(
      //home: HomeScreen(),
      initialRoute: '/',
      // www.google.com -> www.google.com/
      // named route로 네비게이션 활용, argument도 쉽게 전달
      // route 이름이 바뀔 가능성이 있다면 변수를 활용해 관리하자.
      routes: {
        HOME_ROUTE: (context) => HomeScreen(),
        '/one': (context)=>RouteOneScreen(),
        '/two': (context)=>RouteTwoScreen(),
        '/three': (context)=>RouteThreeScreen(),
      },
    ),
  );
}
