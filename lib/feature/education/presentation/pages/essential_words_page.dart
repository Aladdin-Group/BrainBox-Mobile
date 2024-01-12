import 'package:brain_box/feature/education/data/models/book_model.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/education/presentation/widgets/essential_word_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../../core/exceptions/failure.dart';
import '../../data/models/essential_model.dart';
import 'by_word_test_page.dart';

class EssentialWordsPage extends StatefulWidget {
  final Essential essential;
  final int unit;
  final EducationBloc bloc;
  const EssentialWordsPage({super.key,required this.essential,required this.unit,required this.bloc});

  @override
  State<EssentialWordsPage> createState() => _EssentialWordsPageState();
}

class _EssentialWordsPageState extends State<EssentialWordsPage> {

  late FlutterTts flutterTts;
  List<EssentialModel> list = [];
  bool isFail = false;
  bool isLoading = true;
  String languageCode = 'uz';

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    widget.bloc.add(GetWordsEvent(
        essential: widget.essential,
        unit: widget.unit,
        onFail: (Failure fail) { setState(() { isFail = true; }); },
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
    Locale currentLocale = context.locale;
    languageCode = currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Words list'),
      ),
      body: isLoading ? const Center(child: CupertinoActivityIndicator(),) : ListView.builder(
        itemCount: list.length,
          itemBuilder: (context,index){
            return EssentialWordItem(model: list[index], languageCode: languageCode, index: index+1, onClick: ()async{
              await _speak(list[index].word??'NULL_WORD');
            });
          }
      ),
      bottomNavigationBar: isLoading ? const SizedBox.shrink() : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder)=>ByWordTestPage(bloc: widget.bloc,list: list,languageCode: languageCode,)));
            },
            child: const Text('Start test')
        ),
      ),
    );
  }
}
