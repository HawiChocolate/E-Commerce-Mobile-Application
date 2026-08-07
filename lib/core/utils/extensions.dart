extension StringCasingExtension on String {
  /// Capitalizes the first letter of each word.
  /// "men's clothing" -> "Men's Clothing"
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}