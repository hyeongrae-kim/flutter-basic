import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanager/riverpod/state_provider.dart';

import '../layout/default_layout.dart';

// riverpod을 쓰기 위해선 ConsumerWidget을 extend하고, build의 parameter에 WidgetRef ref를 하나 추가해야함
class StateProviderScreen extends ConsumerWidget {
  const StateProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 특정 provider 보다가 그 provider가 변경되면 다시 build -> ref.watch
    final provder = ref.watch(numberProvider);

    return DefaultLayout(
      title: 'StateProviderScreen',
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provder.toString(),
            ),
            ElevatedButton(
              onPressed: () {
                // 사용자로부터 변환을 입력받기 때문에 read, 값을 바꾸기 위해서 notifier를 값 뒤에 붙여야함
                ref.read(numberProvider.notifier).update((state) => state + 1);
              },
              child: Text('UP'),
            ),
            ElevatedButton(
              onPressed: () {
                // 사용자로부터 변환을 입력받기 때문에 read, 값을 바꾸기 위해서 notifier를 값 뒤에 붙여야함
                ref.read(numberProvider.notifier).state = ref.read(numberProvider.notifier).state-1;
              },
              child: Text('DOWN'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _NextScreen(),
                  ),
                );
              },
              child: Text('NextScreen'),
            ),

          ],
        ),
      ),
    );
  }
}

class _NextScreen extends ConsumerWidget {
  const _NextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provder = ref.watch(numberProvider);

    return DefaultLayout(
      title: 'StateProviderScreen',
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provder.toString(),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(numberProvider.notifier).update((state) => state + 1);
              },
              child: Text('UP'),
            ),
          ],
        ),
      ),
    );
  }
}
