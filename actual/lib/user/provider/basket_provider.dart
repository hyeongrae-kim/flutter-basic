import 'package:actual/product/model/product_model.dart';
import 'package:actual/user/model/basket_item_model.dart';
import 'package:actual/user/model/patch_basket_body.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);

    return BasketProvider(
      repository: repository,
    );
  },
);

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({
    required this.repository,
  }) : super([]);

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                productId: e.product.id,
                count: e.count,
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 요청을 먼저 보내고 응답이 오면 캐시를 업데이트 하였다.
    // 네트워크, 서버 등의 문제로 응답이 느려지면 화면 업데이트도 느려짐
    // 서버, 네트워크 과연 에러 날까? -> 에러가 나더라도 인지를 못한다면 그게 크리티컬 할까?
    // 해당 데이터가 중요하지 않아서 에러를 무시하거나, 에러에 따라 업데이트 해도 된다고 생각이 들면,
    // 요청이 성공할 거라는 과정으로 캐시를 먼저 업데이트하고 요청을 할 수 있다.
    // -> Optimistic Response. 응답이 성공할 것이라고 갸정하고 상태를 먼저 업데이트한다.
    // -> 앱이 빨라도록 착시효과를 줄 수 있음.

    // 1) 아직 장바구니에 해당되는 상품이 없다면 장바구니에 상품을 추가한다.
    // 2) 만약에 이미 들어있다면 장바구니에 있는 값에 +1을 한다.

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count + 1,
                  )
                : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
          product: product,
          count: 1,
        ),
      ];
    }

    // optimistic response
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    // true면 count와 관계없이 삭제함
    bool isDelete = false,
  }) async {
    // 1) 장바구니에 상품이 존재할때
    //    1) 상품의 카운트가 1보다 크면 -1한다.
    //    2) 상품의 카운트가 1이면 삭제한다.
    // 2) 상품이 존재하지 않을때는 즉시 함수를 반환하고 아무것도 하지않는다.

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);
    if (existingProduct.count == 1 || isDelete) {
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      state = state
          .map((e) => e.product.id == product.id
              ? e.copyWith(
                  count: e.count - 1,
                )
              : e)
          .toList();
    }

    await patchBasket();
  }
}
