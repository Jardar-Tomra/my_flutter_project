extension FirstOrNullExtension<E> on List<E> {
  E? get firstOrNull => isNotEmpty ? first : null;
  E? firstOrNullWhere(bool Function(E element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}