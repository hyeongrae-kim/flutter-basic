import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanager/riverpod/provider_observer.dart';
import 'package:statemanager/screen/home_screen.dart';

void main() {
  // riverpod 사용할려면 ProviderScope가 제일 상위에 있어야함
  runApp(
    ProviderScope(
      // ProviderScope하위의 모든 Provider가 observer 내에 있는것들에 영향을 받음
      observers: [
        Logger(),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
