class MultiSelectItem<T> {
  final T value; // Can be String, int, or even a custom model
  final String id;
  final String title; // Displayed in bold
  final String? subtitle; // Optional subtitle
  bool isChecked;

  MultiSelectItem({
    required this.id,
    required this.value,
    required this.title,
    this.subtitle,
    this.isChecked = false,
  });
}
