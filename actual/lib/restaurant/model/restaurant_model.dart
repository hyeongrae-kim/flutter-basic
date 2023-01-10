// 받아온 데이터를 그냥 바로쓰면 key값으로 불러올 때 에러가 발생하지 않음!
// 하지만 실제 화면에선 에러발생. 따라서 데이터를 모델링 해야한다.(클래스로)

import 'package:actual/common/const/data.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/utills/data_utills.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

// 아래에 대한 코드가 g.dart에 생성
@JsonSerializable()
class RestaurantModel implements IModelWithId{
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });
  
  factory RestaurantModel.fromJson(Map<String, dynamic> json){
    return _$RestaurantModelFromJson(json);
  }

  // 현재 인스턴스를 json으로 변환 해주는 것
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // factory RestaurantModel.fromJson({
  //   // api를 통해 json 받아오면 거의 무조건 Map<String, dynamic>으로 표현됨.
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl:'http://$ip${json['thumbUrl']}',
  //     // List<dynamic> 을 List<String>으로 변환. 실제로 받아오는 데이터가 dynamic으로 나오지만 String으로 구성되어있어서 가능.
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere(
  //       (e) => e.name == json['priceRange'],
  //     ),
  //     // mapping
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //   );
  // }
}
