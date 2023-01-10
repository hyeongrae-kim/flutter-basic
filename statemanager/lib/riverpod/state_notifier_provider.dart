import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statemanager/model/shopping_item_model.dart';

final shoppingListProvider = StateNotifierProvider<ShoppingListNotifier, List<ShoppingItemModel>>((ref) => ShoppingListNotifier());

// 상태를 관리 할 수 있는 클래스 -> ShoppingListNotifier, 위젯에서 사용할려면 위 처럼 Provider를 만들어줘야함
class ShoppingListNotifier extends StateNotifier<List<ShoppingItemModel>> {
  // 생성자로 처음에 어떤 상태로 초기화할지 표시해야함
  ShoppingListNotifier()
      : super([
          ShoppingItemModel(
            name: '김치',
            quantity: 3,
            hasBought: false,
            isSpicy: true,
          ),
          ShoppingItemModel(
            name: '라면',
            quantity: 5,
            hasBought: false,
            isSpicy: true,
          ),
          ShoppingItemModel(
            name: '삼겹살',
            quantity: 10,
            hasBought: false,
            isSpicy: false,
          ),
          ShoppingItemModel(
            name: '수박',
            quantity: 2,
            hasBought: false,
            isSpicy: false,
          ),
          ShoppingItemModel(
            name: '카스테라',
            quantity: 5,
            hasBought: false,
            isSpicy: false,
          ),
        ]);

  void toggleHasBought({required String name}) {
    // state = 해당 클래스 안의 상태, 여기서는 List<ShoppingItemModel>
    state = state
        .map((e) => e.name == name
            ? ShoppingItemModel(
                name: e.name,
                quantity: e.quantity,
                hasBought: !e.hasBought,
                isSpicy: e.isSpicy,
              )
            : e)
        .toList();
  }
}
