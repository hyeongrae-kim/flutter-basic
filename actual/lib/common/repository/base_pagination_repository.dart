import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';

// RestaurantProvider에서 paginate 함수는 여러곳에서 똑같이 사용 할 수 있는데, repository형태가 사용하는곳 마다 달라 여러곳에 복붙해서 써야함
// repository를 인터페이스를 통해 일반화를 한다면 paginate에 repository 형태를 generic으로 넘겨줘서 해당 paginate함수 또한 복붙필요 없어짐
// 그래서 repository를 일반화 하기 위해 만든 Interface 이다.
// dart 언어에선 Interface가 따로 존재하지 않고, class를 통해 생성할 수 있다.(dart 언어 강의 참고)
abstract class IBasePaginationRepository<T extends IModelWithId>{
  // CursorPagination<T> -> CursorPagination에 들어가는 model은 T타입, T는 IModelWithId를 인터페이스로 갖는 타입이며 id변수를 필수로함
  Future<CursorPagination<T>> paginate({
    // const -> buildtime constant이어야 해서 넣어줌
    PaginationParams? paginationParams = const PaginationParams(),
  });
}