import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';


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
        title: Text('Help & Support'.tr()),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            'Frequently Asked Questions'.tr(),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ExpansionTile(
            title: Text('How do I start learning a new language?'),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('To start learning a new language, first select the language you are interested in from our language list, then choose a movie to watch with dual subtitles.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Can I track my learning progress?'),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Yes, your progress is tracked automatically as you watch movies and complete interactive exercises.'),
              ),
            ],
          ),
          // ... Add more ExpansionTiles for other FAQs
          SizedBox(height: 16),
          Text(
            'Need More Help?'.tr(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'If you have more questions or need further assistance, feel free to contact our support team at aladdinsgroup.uz@gmail.com.'.tr(),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
