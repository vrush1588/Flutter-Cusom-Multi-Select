/// A model class representing an item in the multi-select dialog.
///
/// Each item has an [id], [title], an optional [subtitle], and a [value]
/// (which can be a String, int, or even a custom model).
///
/// The [isChecked] property indicates whether the item is currently selected.
class MultiSelectItem<T> {
  /// The actual value of this item.
  ///
  /// Can be `String`, `int`, or a custom model.
  final T value;

  /// A unique identifier for this item.
  final String id;

  /// The title displayed in bold in the multi-select UI.
  final String title;

  /// An optional subtitle displayed under the [title].
  final String? subtitle;

  /// Whether this item is currently selected.
  ///
  /// Defaults to `false`.
  bool isChecked;

  /// Creates a [MultiSelectItem] with the given [id], [value], [title],
  /// optional [subtitle], and [isChecked] state.
  MultiSelectItem({
    required this.id,
    required this.value,
    required this.title,
    this.subtitle,
    this.isChecked = false,
  });
}
