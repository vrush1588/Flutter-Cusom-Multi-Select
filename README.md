# Flutter Custom Multi Select

[![Flutter CI](https://github.com/vrush1588/Flutter-Cusom-Multi-Select/actions/workflows/flutter.yml/badge.svg)](https://github.com/vrush1588/Flutter-Cusom-Multi-Select/actions/workflows/flutter.yml)

A Flutter package for customizable multi-select dialogs...


A customizable multi-select dialog for Flutter 🚀  
Supports **title, subtitle per item**, custom button styles, and both **Dialog** & **Bottom Sheet** modes.

---

## ✨ Features
- Multi-select dialog with checkboxes ✅
- Item **subtitle support** (rare in other packages!)
- Fully customizable styles (colors, fonts, buttons)
- Works with `showDialog` or bottom sheet
- Easy integration with `StatefulWidget` / `Provider` / `Riverpod`

---

## 🚀 Usage
```dart

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
