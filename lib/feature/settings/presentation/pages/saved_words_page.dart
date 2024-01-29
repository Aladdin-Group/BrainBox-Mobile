import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/feature/settings/presentation/manager/save_words/save_words_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';


class SavedWordsPage extends StatefulWidget {
  const SavedWordsPage({super.key});

  @override
  State<SavedWordsPage> createState() => _SavedWordsPageState();
}

class _SavedWordsPageState extends State<SavedWordsPage> {
  // List<Content> savedWords = [];
  String languageCode = '';

  @override
  void initState() {
    getSaved();
    super.initState();
  }

  void getSaved() {
    setState(() {
      // savedWords = SavedController.getListFromHive();
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    languageCode = currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.savedWords.tr())),
      body: BlocBuilder<SaveWordsBloc, SaveWordsState>(
        bloc: context.read<SaveWordsBloc>()..add(GetSavedWords()),
        builder: (context, state) {
          if (state.status.isInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status.isFailure) {
            return Center(child: Text(state.errorMessage, textAlign: TextAlign.center));
          }
          return state.savedWords.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImages.noFound,
                        height: 100,
                        width: 100,
                      ),
                      const Gap(20),
                      Text(
                        LocaleKeys.noSavedWordsYet.tr(),
                        style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: state.savedWords.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    final saveWord = state.savedWords[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${saveWord.value.toString().toUpperCase()} - ${languageCode == 'ru' ? saveWord.translationRu : saveWord.translationEn}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                            onPressed: () {

                              context.read<SaveWordsBloc>().add(DeleteSavedWord(saveWord.id));
                              // if (savedWords[index].isSaved != null) {
                              //   if (!savedWords[index].isSaved!) {
                              //     SavedController.saveObject(savedWords[index]);
                              //     setState(() {
                              //       savedWords[index].isSaved = true;
                              //     });
                              //     HiveController.saveObject(LocalWord(
                              //         notificationId: HiveController.genericId(),
                              //         id: savedWords[index].id ?? '-1',
                              //         translate: languageCode == 'ru'
                              //             ? savedWords[index].translationRu
                              //             : savedWords[index].translationEn,
                              //         word: savedWords[index].value));
                              //   } else {
                              //     SavedController.removeObjectFromHive(
                              //         savedWords[index].value ?? 'NULL_VALUE');
                              //     setState(() {
                              //       savedWords[index].isSaved = false;
                              //     });
                              //     HiveController.removeObjectFromHive(savedWords[index].id ?? '-1');
                              //   }
                              // }
                            },
                            icon: const Icon(CupertinoIcons.bookmark_fill)),
                        subtitle: Text(saveWord.pronunciation.toString()),
                        leading: CircleAvatar(
                            radius: 25,
                            child: FittedBox(
                                child: Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 20),
                            ))),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Gap(5);
                  },
                );
        },
      ),
    );
  }
}
