import 'package:brain_box/core/singletons/storage/saved_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/singletons/storage/hive_controller.dart';
import '../../../reminder/data/models/local_word.dart';
import '../../../words/data/models/words_response.dart';


class SavedWordsPage extends StatefulWidget {
  const SavedWordsPage({super.key});

  @override
  State<SavedWordsPage> createState() => _SavedWordsPageState();
}

class _SavedWordsPageState extends State<SavedWordsPage> {

  List<Content> savedWords = [];
  String languageCode = '';

  @override
  void initState() {
    getSaved();
    super.initState();
  }

  void getSaved(){
    setState(() {
      savedWords = SavedController.getListFromHive();
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    languageCode = currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved words'.tr()),
      ),
      body: ListView.builder(
          itemCount: savedWords.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 5),
              child: Card(
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${savedWords[index].value.toString().toUpperCase()} - ${languageCode == 'ru' ? savedWords[index].translationRu : savedWords[index].translationEn}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      // Container(width: wordsList[index].secondLanguageValue!.length.toDouble()+30, height: 20,color: Colors.black,)
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: (){
                        if(savedWords[index].isSaved!=null){
                          if(!savedWords[index].isSaved!){
                            SavedController.saveObject(savedWords[index]);
                            setState(() {
                              savedWords[index].isSaved = true;
                            });
                            HiveController.saveObject(LocalWord(notificationId: HiveController.genericId(),id: savedWords[index].id??'-1', translate: languageCode == 'ru' ? savedWords[index].translationRu : savedWords[index].translationEn, word: savedWords[index].value));
                          }else{
                            SavedController.removeObjectFromHive(savedWords[index].value??'NULL_VALUE');
                            setState(() {
                              savedWords[index].isSaved = false;
                            });
                            HiveController.removeObjectFromHive(savedWords[index].id??'-1');
                          }

                        }
                      },
                      icon: savedWords[index].isSaved != null ? ( savedWords[index].isSaved! ? Icon(CupertinoIcons.bookmark_fill) : Icon(CupertinoIcons.bookmark)) : Icon(CupertinoIcons.bookmark)
                  ),
                  subtitle: Text(savedWords[index].pronunciation.toString()),
                  leading: CircleAvatar(radius: 25, child: FittedBox(child: Text('${index+1}',style: const TextStyle(fontSize: 20),))),
                ),
              ),
            );
          }
      ),
    );
  }
}
