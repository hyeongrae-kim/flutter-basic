import 'package:actual/user/model/basket_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_order_body.g.dart';

// Post 할 때 보내는 형식
@JsonSerializable()
class PostOrderBody {
  // frontend에서 id 생성시 무조건 global, unique 해야함
  final String id;
  final List<PostOrderBodyProduct> products;
  final int totalPrice;
  final String createdAt;

  PostOrderBody({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createdAt,
  });

  factory PostOrderBody.fromJson(Map<String, dynamic> json) =>
      _$PostOrderBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PostOrderBodyToJson(this);
}

@JsonSerializable()
class PostOrderBodyProduct {
  final String productId;
  final int count;

  PostOrderBodyProduct({
    required this.productId,
    required this.count,
  });

  factory PostOrderBodyProduct.fromJson(Map<String, dynamic> json)
  => _$PostOrderBodyProductFromJson(json);

  Map<String, dynamic> toJson()=>_$PostOrderBodyProductToJson(this);
}
