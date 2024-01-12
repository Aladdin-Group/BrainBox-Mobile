import 'package:flutter/material.dart';

class SelectableUnitItem extends StatefulWidget {
  final int index;
  final Function(int index) onClick;
  final bool isSelected;
  const SelectableUnitItem({super.key,required this.index,required this.onClick,required this.isSelected,});

  @override
  State<SelectableUnitItem> createState() => _SelectableUnitItemState();
}

class _SelectableUnitItemState extends State<SelectableUnitItem> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: widget.isSelected ? Colors.blue : null, // Change the color based on the selection
        child: ListTile(
          onTap: () {
            widget.onClick(widget.index);
          },
          title: const Text(
            'Unit',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          leading: CircleAvatar(
            child: Text(widget.index.toString()),
          ),
        ),
      ),
    );
  }
}
