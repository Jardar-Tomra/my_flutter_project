import 'package:flutter/material.dart';

class SingleSelectChipList<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onSelectionChanged;

  const SingleSelectChipList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelectionChanged,
  });

  @override
  _SingleSelectChipListState<T> createState() => _SingleSelectChipListState<T>();
}

class _SingleSelectChipListState<T> extends State<SingleSelectChipList<T>> {
  T? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: widget.items.map((item) {
        return ChoiceChip(
          label: Text(item.toString()),
          selected: selectedItem == item,
          onSelected: (isSelected) {
            setState(() {
              selectedItem = isSelected ? item : null;
            });
            widget.onSelectionChanged(selectedItem);
          },
          selectedColor: Colors.blue,
          labelStyle: TextStyle(
            color: selectedItem == item ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}