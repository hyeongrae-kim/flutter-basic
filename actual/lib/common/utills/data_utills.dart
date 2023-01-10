import 'dart:convert';

import '../const/data.dart';

class DataUtils{
  static DateTime stringToDateTime(String value){
    return DateTime.parse(value);
  }

  // JsonKey로 사용할 때 무조건 static을 사용해 주어야함.
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }

  // 서버로부터 올때는 뭔지 몰라서 List paths가 자동으로 다이나믹 형태로 들어오게 됨
  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBase64(String plain){
    // 일반 스트링을 Base64로 변환하기
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}