// 이걸 implement하는 모든 class는 무조건 id값을 가지고 있어야함(강제)
// IModelWithId -> model(레스토랑, 레스토랑디테일, ...)의 인터페이스. id변수를 필수로 가지고 있어야함.
abstract class IModelWithId {
  final String id;

  IModelWithId({
    required this.id,
  });
}
