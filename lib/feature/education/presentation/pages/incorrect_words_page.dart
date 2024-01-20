import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../data/models/essential_model.dart';
import '../widgets/essential_word_item.dart';

class IncorrectWordsPage extends StatefulWidget {
  final List<EssentialModel> list;
  const IncorrectWordsPage({super.key,required this.list});

  @override
  State<IncorrectWordsPage> createState() => _IncorrectWordsPageState();
}

class _IncorrectWordsPageState extends State<IncorrectWordsPage> {

  late FlutterTts flutterTts;
  String languageCode = 'uz';

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
  void initState() {
    flutterTts = FlutterTts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    languageCode = currentLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fail words'),
      ),
      body: ListView.builder(
        itemCount: widget.list.length,
          itemBuilder: (context,index){
            return EssentialWordItem(model: widget.list[index],  index: index+1, onClick: (){
                _speak(widget.list[index].word??'NOT');
              });
          }
      ),
    );
  }
}
