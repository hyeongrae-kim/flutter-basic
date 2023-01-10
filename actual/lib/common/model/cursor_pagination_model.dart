import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

/* class로 상태 구분 만들기 */
// 상태 구분만을 위함이므로 instance화 못하게 하기위해서 abstract 사용
// 빈 클래스를 extend 하나마나 똑같긴 하지만, CursorPaginationBase의 타입이다 라고 말 하기위해서 사용한다.
abstract class CursorPaginationBase {}

// 데이터가 제대로 안왔을 때
class CursorPaginationError extends CursorPaginationBase {
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

// 데이터가 로딩중일때
// 어짜피 로딩중? 데이터가 없을때. 빈 클래스로 그냥 두고 구별하면 됨.
// 이 클래스의 instance인지만 체크하면 된다!
class CursorPaginationLoading extends CursorPaginationBase {}

// 데이터가 제대로 왔을 때
@JsonSerializable(
  // generic을 사용하므로 설정 해줘야함
  genericArgumentFactories: true,
)
class CursorPagination<T> extends CursorPaginationBase {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(
      meta: meta ?? this.meta,
      data: data ?? this.data,
    );
  }

  // fromJsonT -> T라는 타입이 Json으로 부터 어떻게 instance화 하는지 정의
  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

// 데이터를 처음부터 불러오기(화면을 새로고침 할때)
// 이미 데이터가 있는 상태에서 새로고침을 하니까 Base가 아닌 그냥 Pagination을 extend 한다.
// 상속이 된 클래스에 의해 상속이 되고 있으니까 결국은 CursorPaginationBase에 상속되고 있다!
// CursorPaginationBase -> CursorPagination -> CursorPaginationRefetching
class CursorPaginationRefetching<T> extends CursorPagination<T> {
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 리스트의 맨 아래로 내려서 추가 데이터를 요청하는 중
// 로딩을 쓰는 순간 기존 리스트에서 데이터는 다 사라지니까 사용할 수 없다!
class CursorPaginationFetchingMore<T> extends CursorPagination<T> {
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
