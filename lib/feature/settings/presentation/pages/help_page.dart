import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:gap/gap.dart';
import 'package:gap/gap.dart';


class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {


  ValueNotifier<String> mode = ValueNotifier('user');

  @override
  void initState() {
    super.initState();
  }

  Future checkDevMode()async{
    bool developerMode = await FlutterJailbreakDetection.developerMode;
    if(developerMode){
      mode.value = 'Developer!';
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.helpSupport.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
           LocaleKeys.frequentlyAskedQuestions.tr(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
           ExpansionTile(
            // title: Text('How do I start learning a new language?'),
            title: Text(LocaleKeys.howDoIStartLearningANewLanguage.tr()),
            children:  <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(LocaleKeys.howDoIStartLearningANewLanguage.tr()),
              ),
            ],
          ),
           ExpansionTile(
            // title: Text('Can I track my learning progress?'),
            title: Text(LocaleKeys.canITrackMyLearningProgress.tr()),
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Yes, your progress is tracked automatically as you watch movies and complete interactive exercises.'),
              ),
            ],
          ),
          // ... Add more ExpansionTiles for other FAQs
          const Gap(16),
          Text(
            LocaleKeys.needMoreHelp.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            LocaleKeys.ifYouHaveMoreQuestionsOrNeedFurtherAssistanceFeelFreeToContactOurSupportTeamAtAladdinsgroup.tr(),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
