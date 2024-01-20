import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/education/presentation/widgets/essential_word_item.dart';
import 'package:brain_box/feature/settings/data/repositories/language_repo.dart';
import 'package:brain_box/feature/settings/presentation/manager/settings/settings_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gap/gap.dart';

import '../../../../core/exceptions/failure.dart';
import '../../data/models/essential_model.dart';
import 'by_word_test_page.dart';

class EssentialWordsPage extends StatefulWidget {
  final Essential essential;
  final int unit;

  const EssentialWordsPage({super.key, required this.essential, required this.unit});

  @override
  State<EssentialWordsPage> createState() => _EssentialWordsPageState();
}

class _EssentialWordsPageState extends State<EssentialWordsPage> {
  late FlutterTts flutterTts;
  List<EssentialModel> list = [];
  bool isFail = false;
  bool isLoading = true;
  // String languageCode = 'uz';

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    context.read<EducationBloc>().add(GetWordsEvent(
      essential: widget.essential,
      unit: widget.unit,
      onFail: (Failure fail) {
        setState(() {
          isFail = true;
        });
      },
      onSuccess: (List<EssentialModel> result) {
        setState(() {
          isLoading = false;
          list.addAll(result);
        });
      },
    ));
  }

  Future _speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    // Locale currentLocale = context.locale;
    // languageCode = currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit ${widget.unit}'),
        actions: [
          IconButton(
              onPressed: () {
                // show dialog which contains DropDownMenu for change language, switch for hide and show word translations and slider for manage word font size
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(LocaleKeys.settings.tr()),
                              IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close))
                            ],
                          ),
                          content: Column(mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                            DropdownButton(

                              value: context
                                  .watch<SettingsBloc>()
                                  .state
                                  .languageModel,
                              onChanged: (language) {
                                context.read<SettingsBloc>().add(ChangeLanguageEvent(languageModel: language!));

                              },
                              isExpanded: true,
                              items: LanguageRepository.languages.map((language) {
                                return DropdownMenuItem(
                                  value: language,
                                  child: Text(language.name),
                                );
                              }).toList(),
                            ),
                            SwitchListTile(
                                title:  Text(LocaleKeys.showTranslations.tr()),
                                value: context
                                    .watch<EducationBloc>()
                                    .state
                                    .showTranslation,
                                onChanged: (value) => context.read<EducationBloc>().add(ShowTranslationsEvent())),
                            Row(
                              children: [
                                const Text('A', style: TextStyle(fontSize: 14)),
                                Slider(
                                  min: 12,
                                  max: 20,
                                  divisions: 10,
                                  value: context
                                      .watch<EducationBloc>()
                                      .state
                                      .fontSize,
                                  onChanged: (fontSize) =>
                                      context.read<EducationBloc>().add(ChangeWordFontSize(fontSize)),
                                ),
                                const Text('A', style: TextStyle(fontSize: 24)),
                              ],
                            )
                          ]));
                    });
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return EssentialWordItem(
                model: list[index],
                // languageCode: languageCode,
                index: index + 1,
                onClick: () async {
                  await _speak(list[index].word ?? 'NULL_WORD');
                });
          }),
      bottomNavigationBar: isLoading
          ? const SizedBox.shrink()
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) =>
                          ByWordTestPage(
                            list: list,
                            // languageCode: languageCode,
                          )));
            },
            child: const Text('Start test')),
      ),
    );
  }
}
