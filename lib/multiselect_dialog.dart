import 'package:flutter/material.dart';

import 'util/multiselect_item.dart';

/// Defines the display type for [MultiSelectDialog].
///
/// - [alert]: Displays the dialog as a traditional `AlertDialog`.
/// - [bottomSheet]: Displays the dialog as a `BottomSheet`.
enum DialogDisplayType { alert, bottomSheet }

/// A customizable multi-select dialog for Flutter.
///
/// The [MultiSelectDialog] allows users to select multiple options from a list
/// with support for search, titles, subtitles, and custom styling. The dialog
/// can be displayed either as an [AlertDialog] or as a [BottomSheet].
class MultiSelectDialog extends StatefulWidget {
  /// The title displayed at the top of the dialog.
  final String title;

  /// An optional subtitle displayed below the [title].
  final String? subtitle;

  /// The list of items to display in the dialog.
  final List<MultiSelectItem> items;

  /// Preselected items when the dialog is first displayed.
  final List<MultiSelectItem>? selectedItems;

  /// Callback triggered when the user presses the confirm button.
  ///
  /// Provides the list of selected [MultiSelectItem]s.
  final Function(List<MultiSelectItem>) onConfirm;

  /// Background color of the dialog.
  final Color? backgroundColor;

  /// Custom text style for the [title].
  final TextStyle? titleStyle;

  /// Custom text style for the [subtitle].
  final TextStyle? subtitleStyle;

  /// Custom text style for each item title in the list.
  final TextStyle? itemTitleStyle;

  /// Custom text style for each item subtitle in the list.
  final TextStyle? itemSubtitleStyle;

  /// Text for the cancel button (default: `"Cancel"`).
  final String cancelText;

  /// Text for the confirm button (default: `"Done"`).
  final String confirmText;

  /// Custom style for the cancel button.
  final ButtonStyle? cancelButtonStyle;

  /// Custom style for the confirm button.
  final ButtonStyle? confirmButtonStyle;

  /// Determines how the dialog is displayed.
  ///
  /// Defaults to [DialogDisplayType.alert].
  final DialogDisplayType displayType;

  /// Creates a new [MultiSelectDialog].
  ///
  /// Requires a [title], [items], and an [onConfirm] callback.
  const MultiSelectDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.items,
    this.selectedItems,
    required this.onConfirm,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.itemTitleStyle,
    this.itemSubtitleStyle,
    this.cancelText = "Cancel",
    this.confirmText = "Done",
    this.cancelButtonStyle,
    this.confirmButtonStyle,
    this.displayType = DialogDisplayType.alert,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  /// A temporary working list of items used for selection state.
  late List<MultiSelectItem> tempList;

  /// Controller for the search bar input.
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tempList = List.from(widget.items);
    if (widget.selectedItems != null) {
      for (var selected in widget.selectedItems!) {
        final idx = tempList.indexWhere((e) => e.id == selected.id);
        if (idx != -1) tempList[idx].isChecked = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.toLowerCase();
    final filteredList = tempList
        .where((item) => item.title.toLowerCase().contains(query))
        .toList();

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title + subtitle
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: widget.titleStyle ??
                      const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(widget.subtitle!,
                    style: widget.subtitleStyle ??
                        const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Search
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),

        // List → For bottomSheet, height is handled by DraggableScrollableSheet
        if (widget.displayType == DialogDisplayType.bottomSheet)
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (ctx, index) => _buildItemTile(filteredList[index]),
            ),
          )
        else
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (ctx, index) => _buildItemTile(filteredList[index]),
            ),
          ),

        const SizedBox(height: 8),

        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                style: widget.cancelButtonStyle,
                onPressed: () => Navigator.pop(context),
                child: Text(widget.cancelText)),
            ElevatedButton(
                style: widget.confirmButtonStyle,
                onPressed: () {
                  widget.onConfirm(tempList.where((e) => e.isChecked).toList());
                  Navigator.pop(context);
                },
                child: Text(widget.confirmText)),
          ],
        ),
      ],
    );

    // BottomSheet Mode
    if (widget.displayType == DialogDisplayType.bottomSheet) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: content,
        ),
      );
    }

    // Default → AlertDialog
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20.0),
      backgroundColor: widget.backgroundColor ??
          Theme.of(context).dialogTheme.backgroundColor ??
          Theme.of(context).colorScheme.surface,
      content: SizedBox(width: double.maxFinite, child: content),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Builds a single list item (checkbox tile) inside the dialog.
  Widget _buildItemTile(MultiSelectItem item) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      value: item.isChecked,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title,
              style: widget.itemTitleStyle ??
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (item.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(item.subtitle!,
                style: widget.itemSubtitleStyle ??
                    const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (val) {
        setState(() {
          item.isChecked = val ?? false;
          final idx = tempList.indexWhere((e) => e.id == item.id);
          if (idx != -1) tempList[idx].isChecked = val ?? false;
        });
      },
    );
  }
}
