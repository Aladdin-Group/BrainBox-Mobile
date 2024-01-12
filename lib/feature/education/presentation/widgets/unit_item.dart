import 'package:flutter/material.dart';

class UnitItem extends StatelessWidget {
  final int index;
  final Function(int index) onClick;
  const UnitItem({super.key,required this.index,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: ListTile(onTap: ()=>onClick(index),
            title: const Text(
              'Unit',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            leading: CircleAvatar(
              child: Text(index.toString()),
            ),
            trailing: const Icon(Icons.arrow_forward_outlined),
          )
      ),
    );
  }
}
