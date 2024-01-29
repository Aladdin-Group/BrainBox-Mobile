import 'package:brain_box/feature/education/data/models/essential_model.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/settings/presentation/manager/settings/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EssentialWordItem extends StatelessWidget {
  final EssentialModel model;

  // final String languageCode;
  final int index;
  final Function onClick;

  const EssentialWordItem({super.key, required this.model, required this.index, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              '${model.word} ${context.watch<EducationBloc>().state.showTranslation ? "- ${context.read<SettingsBloc>().state.languageModel.shortName == 'ru' ? model.translationRu : model.translationEn}" : ''}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.read<EducationBloc>().state.fontSize),
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        child: Text(index.toString()),
      ),
      // trailing: IconButton(onPressed: ()=>onClick(), icon: const Icon(Icons.volume_up)),
      trailing: IconButton(
          onPressed: () {
            FlutterTts().speak(model.word ?? "");
          },
          icon: const Icon(Icons.volume_up)),
    );
  }
}
