import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logger extends ProviderObserver{
  // Logger가 들어있는 영역에 있는 Provider가 update 될 때마다 실행되는 함수
  // Param : 업데이트 된 provider, 기존값, 다음값, ...
  @override
  void didUpdateProvider(ProviderBase provider, Object? previousValue, Object? newValue, ProviderContainer container) {
    print('[Provider Updated] provder: $provider / pv: $previousValue / nv: $newValue');
  }

  // provider를 추가했을 때 실행되는 함수
  @override
  void didAddProvider(ProviderBase provider, Object? value, ProviderContainer container) {
    print('[Provider Added] provder: $provider / value: $value');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    print('[Provider Disposed] provider: $provider');
  }
}