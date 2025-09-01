import 'package:flutter/material.dart';
import 'util/multiselect_item.dart';

enum DialogDisplayType { alert, bottomSheet }

class MultiSelectDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<MultiSelectItem> items;
  final List<MultiSelectItem>? selectedItems;
  final Function(List<MultiSelectItem>) onConfirm;

  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? itemTitleStyle;
  final TextStyle? itemSubtitleStyle;

  final String cancelText;
  final String confirmText;

  final ButtonStyle? cancelButtonStyle;
  final ButtonStyle? confirmButtonStyle;

  final DialogDisplayType displayType;

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
  late List<MultiSelectItem> tempList;
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
    final filteredList =
    tempList.where((item) => item.title.toLowerCase().contains(query)).toList();

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
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            prefixIcon: Icon(Icons.search),
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
      contentPadding: EdgeInsets.all(20.0),
      backgroundColor: widget.backgroundColor ??
          Theme.of(context).dialogTheme.backgroundColor ??
          Theme.of(context).colorScheme.surface,
      content: SizedBox(width: double.maxFinite, child: content),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // 👈 set lower radius here
      ),
    );
  }

  Widget _buildItemTile(MultiSelectItem item) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
