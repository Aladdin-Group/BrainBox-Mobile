
import 'package:brain_box/feature/words/data/models/words_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/assets/constants/icons.dart';

class TestResultPage extends StatefulWidget {
  List<Content> inCorrectAnswer;
  TestResultPage({Key? key,required this.inCorrectAnswer}) : super(key: key);

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {

  String languageCode = '';

  @override
  Widget build(BuildContext context) {

    Locale currentLocale = context.locale;
    languageCode = currentLocale.languageCode;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 2,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Available seats'),
                background: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset(AppIcons.correct),
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Add new entry',
                  onPressed: () { /* ... */ },
                ),
              ]
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: widget.inCorrectAnswer.length,(context, index) => ListTile(
                      title: Text('${widget.inCorrectAnswer[index].value} - ${languageCode == 'ru' ? widget.inCorrectAnswer[index].translationRu : widget.inCorrectAnswer[index].translationEn}'),
              ))
          )
        ],
      ),
    );
  }
}