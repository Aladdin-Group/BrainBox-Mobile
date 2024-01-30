import 'package:brain_box/core/singletons/storage/saved_controller.dart';
import 'package:brain_box/feature/education/data/models/essential_model.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';

// import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/settings/presentation/manager/settings/settings_bloc.dart';
import 'package:brain_box/feature/words/data/models/words_response.dart';
import 'package:brain_box/feature/words/presentation/manager/words_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EssentialWordItem extends StatefulWidget {
  final EssentialModel model;

  // final String languageCode;
  final int index;
  final Function onClick;

  const EssentialWordItem({super.key, required this.model, required this.index, required this.onClick});

  @override
  State<EssentialWordItem> createState() => _EssentialWordItemState();
}

class _EssentialWordItemState extends State<EssentialWordItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              '${widget.model.word} ${context.watch<EducationBloc>().state.showTranslation ? "- ${context.read<SettingsBloc>().state.languageModel.shortName == 'ru' ? widget.model.translationRu : widget.model.translationEn}" : ''}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.read<EducationBloc>().state.fontSize),
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        child: Text(widget.index.toString()),
      ),
      // trailing: IconButton(onPressed: ()=>onClick(), icon: const Icon(Icons.volume_up)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                if (SavedController.getListFromHive().any((element) => element.value == widget.model.word)) {
                  SavedController.removeObjectFromHive(widget.model.id.toString());
                  setState(() {});
                  return;
                }
                SavedController.saveObject(Content(
                    id: widget.model.id.toString(),
                    value: widget.model.word,
                    translationRu: widget.model.translationRu,
                    translationEn: widget.model.translationEn));
                setState(() {});
                // context.read<WordsBloc>().add(SaveOrRemoveWord(
                //       Content(
                //           id: model.id.toString(),
                //           value: model.word,
                //           translationRu: model.translationRu,
                //           translationEn: model.translationEn),
                //     ));
              },
              icon: Icon(SavedController.getListFromHive().any((element) => element.value == widget.model.word)
                  ? Icons.bookmark
                  : Icons.bookmark_border)),
          IconButton(
              onPressed: () {
                FlutterTts().speak(widget.model.word ?? "");
              },
              icon: const Icon(Icons.volume_up)),
        ],
      ),
    );
  }
}
