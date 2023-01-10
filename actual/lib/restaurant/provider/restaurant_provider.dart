import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../repository/restaurant_repository.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  // id = 가져오고싶은 상세정보 레스토랑 id
  final state = ref.watch(restaurantProvider);

  // state가 CursorPagination이 아니면 어짜피 데이터가 안에 없다는 뜻
  if (state is! CursorPagination) {
    return null;
  }

  // 위의 if에서 검사하면서 state가 CursorPagination으로 자동 캐스팅됨
  // final pState = state as CursorPagination;

  // firstWhere -> data없으면 오류 반환한
  // 이것을 방지하기 위해 collection package내의 firstWhereOrNull 사용
  // 데이터가 없으면 null 반환
  return state.data.firstWhereOrNull((element) => element.id == id);
  // data를 이미 메모리에 있는 restaurantProvider에서 필요한 부분만 긁어온다.
  // 따라서 로딩없이 바로 빠르게 불러오기가 가능함.
});

// 캐싱을 위한 provider
final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);

    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

// class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
class RestaurantStateNotifier extends PaginationProvider<RestaurantModel, RestaurantRepository>{
  // final RestaurantRepository repository;

  RestaurantStateNotifier({
    // required this.repository,
    required super.repository,
  });
  // }) : super(CursorPaginationLoading()) {
  //   // 생성자에 함수를 넣으면 RestaurantStateNotifier class가 생성 되었을때(instance 되었을 때) 함수 실행됨.
  //   paginate();
  // }

  // StateNotifier를 extend하는 PaginationProvider를 extend하여서 쓸모 없어짐
  // Future<void> paginate({
  //   int fetchCount = 20,
  //   // 추가로 데이터 더 가져오기
  //   // true - 추가로 데이터 더 가져옴, false - 새로고침(처음 데이터를 가져옴, 현재 상태 덮어씌움)
  //   // 화면에 있는 내용 안지우고 새로고침
  //   bool fetchMore = false,
  //   // 강제로 다시 로딩하기
  //   // true - CursorPaginationLoading()
  //   // 화면에 있는 내용 지우고 로딩바 띄운 후 불러오기
  //   bool forceRefetch = false,
  // }) async {
  //   try {
  //     // 5가지 가능성
  //     // state 상태
  //     // [상태가]
  //     // 1) CursorPagination - 정상적으로 데이터가 있는 상태
  //     // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음, forceRefetch=true)
  //     // 3) CursorPaginationError - 에러가 있는 상태
  //     // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때
  //     // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때
  //
  //     // 바로 반환하는 상황
  //     // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
  //     // hasMore은 데이터를 가져온적이 있어야지 값을 알 수 있음.(Loading, Error엔 이 값이 없다.)
  //     // 2) 로딩중인 상황이면서 fetchMore = true일 때(원래 로딩중엔 요청이 안들어가지만, 혹시나 들어갈 경우도 대비해서)
  //     // => 추가 데이터를 가지고오는 상황에서 다시 paginate를 실행 할 때(추가 데이터를 부른게 들어오기 전 다시 호출될 때를 방지)
  //     // But. 로딩중인데 fetchMore가 아닐 때는 새로고침의 의도가 있을 수 있다. -> 이 때는 바로반환 안함
  //
  //     // 1번 반환 상황
  //     if (state is CursorPagination && !forceRefetch) {
  //       // -> (데이터를 가지고 있는 상황에서, 강제로 새로고침을 하라는 명령이 없을 때 [강제로 새로고침하는 경우는 뭐라도 반환 해야함!])
  //       final pState = state as CursorPagination;
  //       // **state를 CursorPagination으로 강제 고정한 이유**
  //       // foreceRefetch까지 false면 강제로 새로고침 하지 않으므로 상태가 무조건 CursorPagination인 것들만 들어올 수 있음.
  //       // 하지만 state의 정의 상 Base로 지정을 해놓아서 CursorPagination안의 기능을 사용하기 위해 강제로 state 지정 필요
  //       if (!pState.meta.hasMore) {
  //         // -> (hasMore가 false면 추가로 불러올 데이터가 없으므로 반환해줄 데이터가 없으므로 그냥 바로 반환!)
  //         return;
  //       }
  //     }
  //     // 2번 반환 상황
  //     final isLoading = state is CursorPaginationLoading;
  //     final isRefetching = state is CursorPaginationRefetching;
  //     final isFetchingMore = state is CursorPaginationFetchingMore;
  //     // fetchMore = True에 로딩중이라 데이터를 추가로 받아오는 상황에서, 추가로 데이터 요청을 받은 상황.
  //     if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
  //       return;
  //     }
  //
  //     // PaginationParams 생성
  //     PaginationParams paginationParams = PaginationParams(
  //       count: fetchCount,
  //     );
  //
  //     // fetchMore
  //     // 데이터를 추가로 더 가져오는 상황
  //     // fetchMore -> 기존 데이터가 있는 상황, 무조건 CursorPagination을 extend한 상태(또는 본인)가 들어오게 됨.
  //     if (fetchMore) {
  //       final pState = state as CursorPagination;
  //
  //       state = CursorPaginationFetchingMore(
  //         meta: pState.meta,
  //         data: pState.data,
  //       );
  //
  //       paginationParams = paginationParams.copyWith(
  //         after: pState.data.last.id,
  //       );
  //     }
  //     // 데이터를 처음부터 가져오는 상황(처음 가져오거나, 강제로 새로고침 하는 상황)
  //     else {
  //       // 만약에 데이터가 있는 상황이라면
  //       // 기존 데이터를 보존한채로 Fetch(API요청)를 진행
  //       if (state is CursorPagination && !forceRefetch) {
  //         final pState = state as CursorPagination;
  //
  //         state = CursorPaginationRefetching(
  //           meta: pState.meta,
  //           data: pState.data,
  //         );
  //       }
  //       // 나머지 상황 (데이터 유지가 필요 없는)
  //       // 기존 데이터(캐시)가 없거나, 강제로 새로고침 하는 상황
  //       else {
  //         state = CursorPaginationLoading();
  //       }
  //     }
  //
  //     // 상태가 뭐든, 데이터는 가져와야한다. 공통된 부분(데이터를 안가져와도 되는 부분은 처음 반환상황에서 다 클리어)
  //     final resp = await repository.paginate(
  //       paginationParams: paginationParams,
  //     );
  //
  //     if (state is CursorPaginationFetchingMore) {
  //       final pState = state as CursorPaginationFetchingMore;
  //
  //       // 기존 데이터에 새로운 데이터 추가
  //       // 로딩이 끝났으므로, 상태를 CursorPaginationFetchingMore에서 CursorPagination으로 변경해 주어야하는데,
  //       // repository.paginate 함수는 CursorPagination으로 반환되게 설정했기 때문에 변경할필요없음.
  //       state = resp.copyWith(
  //         data: [
  //           ...pState.data,
  //           ...resp.data,
  //         ],
  //       );
  //     }
  //     // 맨 처음 20개 데이터 가져오는 경우. CursorPaginationLoading, CursorPaginationRefetching
  //     else {
  //       state = resp;
  //     }
  //   } catch (e) {
  //     state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
  //   }
  // }

  void getDetail({
    required String id,
  }) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await this.paginate();
    }

    // state가 CursorPagination이 아닐 때 그냥 리턴(서버에서 에러상황!!)
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    // resp에는 RestaurantDetailModel이 들어가게 됨(id값에 해당되는)
    final resp = await repository.getRestaurantDetail(id: id);

    // **
    // [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
    // 요청 id: 10 이면 데이터가 없어서 못 불러옴.
    // 데이터가 없을때는 그냥 캐시의 끝에다가 데이터를 추가해버린다.
    // 요청 id: 10
    // ->[RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3). RestaurantDetailModel(10)]
    if(pState.data.where((e) => e.id == id).isEmpty){
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ],
      );
    }else{
      // state안에 detail screen을 요청한 id에 해당되는 값을 detailmodel로 변경해준다.
      // [RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
      // id: 2인 친구를 Detail Model을 가져와라
      // => [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? resp : e,
        )
            .toList(),
      );
    }
  }
}
