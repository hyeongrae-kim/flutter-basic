import 'package:flutter_riverpod/flutter_riverpod.dart';

// generic에 <return type, data type> 두개 넣어줘야함
final familyModifierProvider = FutureProvider.family<List<int>, int>((ref, data) async {
  await Future.delayed(Duration(seconds: 2));

  return List.generate(5, (index) => index*data);
});