import 'package:flutter/material.dart';
import 'package:flutter_custom_multi_select/multiselect_dialog.dart';
import 'package:flutter_custom_multi_select/util/multiselect_item.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, // 👈 remove debug banner
    home: MultiSelectDemo(),
  ));
}
class MultiSelectDemo extends StatefulWidget {
  const MultiSelectDemo({super.key});

  @override
  State<MultiSelectDemo> createState() => _MultiSelectDemoState();
}

class _MultiSelectDemoState extends State<MultiSelectDemo> {
  List<MultiSelectItem> items = [
    MultiSelectItem(id: "1", value: 1, title: "Apple", subtitle: "Fruit"),
    MultiSelectItem(id: "2", value: 2, title: "Banana", subtitle: "Fruit"),
    MultiSelectItem(id: "3", value: 3, title: "Carrot", subtitle: "Vegetable"),
    MultiSelectItem(id: "4", value: 4, title: "Orange", subtitle: "Fruit"),
    MultiSelectItem(id: "5", value: 5, title: "Tomato", subtitle: "Vegetable"),
    MultiSelectItem(id: "6", value: 6, title: "Grapes", subtitle: "Fruit"),
    MultiSelectItem(id: "7", value: 7, title: "Potato", subtitle: "Vegetable"),
    MultiSelectItem(id: "8", value: 8, title: "Mango", subtitle: "Fruit"),
  ];


  List<MultiSelectItem> selectedItems = [];



  void _openDialog() {
    showDialog(
      context: context,
      builder: (ctx) => MultiSelectDialog(
        title: "Select Favourite",
        subtitle: "Select multiple options",
        items: items,
        selectedItems: selectedItems,
        onConfirm: (selected) =>{
          this.selectedItems=selected,
          print(selected),
          setState(() {

          })
        },
        // 🎨 Customizations
        backgroundColor: Colors.white,
        titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        subtitleStyle: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
        itemTitleStyle: const TextStyle(fontSize: 16, color: Colors.indigo),
        itemSubtitleStyle: const TextStyle(fontSize: 14, color: Colors.black54),

        cancelText: "Dismiss",
        confirmText: "Apply",

        cancelButtonStyle: TextButton.styleFrom(
          foregroundColor: Colors.red,
        ),
        confirmButtonStyle: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(color: Colors.white)
        ),
      ),
    );

  }
  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // important for full height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false, // so it doesn’t take full screen by default
          initialChildSize: 0.7, // peek height (70% of screen)
          minChildSize: 0.3,     // minimum when collapsed
          maxChildSize: 0.9,     // maximum when expanded
          builder: (context, scrollController) {
            // Pass the scrollController to the MultiSelectDialog
            return MultiSelectDialog(
              title: "Select Fruits",
              subtitle: "Pick multiple options",
              items: items,
              selectedItems: selectedItems,
              onConfirm: (selected) {
                setState(() => selectedItems = selected);
              },
              displayType: DialogDisplayType.bottomSheet,
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multi Select Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _openDialog,
              child: const Text("Open as AlertDialog"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openBottomSheet,
              child: const Text("Open as BottomSheet"),
            ),
            const SizedBox(height: 20),
            Text(
              "Selected: ${selectedItems.map((e) => e.title).join(", ")}",
            ),
          ],
        ),
      ),
    );
  }

}
