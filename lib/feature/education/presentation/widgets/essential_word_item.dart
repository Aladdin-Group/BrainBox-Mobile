import 'package:brain_box/feature/education/data/models/essential_model.dart';
import 'package:flutter/material.dart';

class EssentialWordItem extends StatelessWidget {
  final EssentialModel model;
  final String languageCode;
  final int index;
  final Function onClick;
  const EssentialWordItem({super.key,required this.model,required this.languageCode,required this.index,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              '${model.word} - ${languageCode == 'ru' ? model.translationRu : model.translationEn}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
      leading: CircleAvatar(child: Text(index.toString()),),
      trailing: IconButton(onPressed: ()=>onClick(), icon: const Icon(Icons.volume_up)),
    );
  }
}
