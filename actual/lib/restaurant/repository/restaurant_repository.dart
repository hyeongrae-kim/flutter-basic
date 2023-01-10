import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
  (ref) {
    // provider안에서는 되도록 read보다는 watch
    final dio = ref.watch(dioProvider);

    final repository =
        RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return repository;
  },
);

// retrofit -> 요청하고 리턴받는거 편하게 해주는 거
// repository class -> instance화 방지를 위해서 무조건 abstract class로 생성
// implements? IBasePaginationRepository 안에 있는 함수들을 똑같이 정의해야 하는데, 데이터 타입은 RestaurantModel이 될거다.
// IBasePaginationRepository는 paginate함수를 들고 있고, RestaurantRepository는 이를 implement 하기때문에
// 다트sdk는 아래의 클래스에 paginate함수가 무조건 있다는 것을 알 수 있다.
@RestApi()
abstract class RestaurantRepository implements IBasePaginationRepository<RestaurantModel>{
  // baseUrl =  http://$ip/restaurant
  // retrofit의 standard에 맞추기위해서 아래와 같은 방식으로 작성
  // factory는 =을 통해 함수바디를 생성 가능
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // Get안의 url은 baseUrl + /
  // abstract class이므로 body를 정의하진 않음. 기준을 보고 retrofit이 함수를 알아서 정의함
  @GET('/')
  @Headers({
    // 여기선 매번 토큰을 가져올 수 없음
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    // const -> buildtime constant이어야 해서 넣어줌
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // retrofit에선 변수를 {}안에 넣는다
  // baseUrl + /:id
  // retrofit에서는 restapi로 받아오는 데이터 형식과 모델 class 형식이 완전히 똑같아야지 쓸수있음.
  @GET('/{id}')
  @Headers({
    // 여기선 매번 토큰을 가져올 수 없음
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    // id라는 Path안에있는 변수를 위의 Get언에 변수로 대치 할 수 있음(변수이름을 보고 대치) 변수이름이 다르다면 Path()안에 변수이름 스트링으로
    @Path() required String id,
  });
}
