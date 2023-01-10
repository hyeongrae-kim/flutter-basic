import 'package:actual/common/component/pagination_list_view.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../provider/restaurant_provider.dart';

// 스크롤 포지션을 알아야지 위치를 확인하고 데이터 요청을 하므로 Stateful Widget을 사용함.
// class RestaurantScreen extends ConsumerStatefulWidget {
//   const RestaurantScreen({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
// }

class RestaurantScreen extends StatelessWidget {
  // **PaginationListView로 일반화 하면서 필요 없어짐
  // final ScrollController controller = ScrollController();
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   controller.addListener(scrollListener);
  // }
  //
  // void scrollListener() {
  //   PaginationUtils.paginate(
  //     controller: controller,
  //     provider: ref.read(
  //       restaurantProvider.notifier,
  //     ),
  //   );
  //   // // 현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면
  //   // // 새로운 데이터를 추가요청
  //   // // hasMore가 true? false? 이런거는 provider안에서 구현 했기때문에 신경쓸 필요없음
  //   // if (controller.offset > controller.position.maxScrollExtent - 300) {
  //   //   ref.read(restaurantProvider.notifier).paginate(
  //   //         fetchMore: true,
  //   //       );
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            // goNamed가 아닌 go를 쓴다면 id값 직접 넣어주면 됨
            // context.go('/restaurant/${model.id}');
            context.goNamed(
              RestaurantDetailScreen.routeName,
              // state를 통해 전달하고자 한다면 params 파라미터를 추가하여 맵 형태로 key, value를 전달한다
              params: {
                'rid': model.id,
              },
            );
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => RestaurantDetailScreen(
            //       id: model.id,
            //     ),
            //   ),
            // );
          },
          child: RestaurantCard.fromModel(
            model: model,
          ),
        );
      },
    );
    //
    // final data = ref.watch(restaurantProvider);
    //
    // // 완전 처음 로딩일때
    // if (data is CursorPaginationLoading) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    //
    // // 에러
    // if (data is CursorPaginationError) {
    //   return Center(
    //     child: Text(
    //       data.message,
    //     ),
    //   );
    // }
    //
    // // CursorPagination
    // // CursorPaginationFetchingMore
    // // CursorPaginationRefetching
    //
    // final cp = data as CursorPagination;
    //
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //   child: ListView.separated(
    //     controller: controller,
    //     itemCount: cp.data.length + 1,
    //     itemBuilder: (_, index) {
    //       if (index == cp.data.length) {
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(
    //             horizontal: 16.0,
    //             vertical: 8.0,
    //           ),
    //           child: Center(
    //             child: data is CursorPaginationFetchingMore
    //                 ? CircularProgressIndicator()
    //                 : Text('마지막 데이터입니다ㅠㅠ'),
    //           ),
    //         );
    //       }
    //
    //       final pItem = cp.data[index];
    //       // parsed
    //       // final pItem = RestaurantModel.fromJson(item);
    //       return GestureDetector(
    //         onTap: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (_) => RestaurantDetailScreen(
    //                 id: pItem.id,
    //               ),
    //             ),
    //           );
    //         },
    //         child: RestaurantCard.fromModel(
    //           model: pItem,
    //         ),
    //       );
    //     },
    //     separatorBuilder: (_, index) {
    //       return SizedBox(height: 16.0);
    //     },
    //   ),
    //   // FutureBuilder 단점 : 마음대로 어디에서든 캐시를 가져오는게 불가능.
    //   // 따라서 RiverPod의 상태관리를 활용하여 사용
    //   // child: FutureBuilder<CursorPagination<RestaurantModel>>(
    //   // Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
    //   //   future: ref.watch(restaurantRepositoryProvider).paginate(),
    //   //   builder: (context, AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
    //   //     if (!snapshot.hasData) {
    //   //       return Center(
    //   //         child: CircularProgressIndicator(),
    //   //       );
    //   //     }
    //   //     return ListView.separated(
    //   //       itemBuilder: (_, index) {
    //   //         final pItem = snapshot.data!.data[index];
    //   //         // parsed
    //   //         // final pItem = RestaurantModel.fromJson(item);
    //   //         return GestureDetector(
    //   //           onTap: () {
    //   //             Navigator.of(context).push(
    //   //               MaterialPageRoute(
    //   //                 builder: (_) => RestaurantDetailScreen(
    //   //                   id: pItem.id,
    //   //                 ),
    //   //               ),
    //   //             );
    //   //           },
    //   //           child: RestaurantCard.fromModel(
    //   //             model: pItem,
    //   //           ),
    //   //         );
    //   //       },
    //   //       separatorBuilder: (_, index) {
    //   //         return SizedBox(height: 16.0);
    //   //       },
    //   //       itemCount: snapshot.data!.data.length,
    //   //     );
    //   //   },
    //   // ),
    // );
  }
}
