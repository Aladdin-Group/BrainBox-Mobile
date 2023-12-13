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
      body: ValueListenableBuilder(
        valueListenable: mode,
        builder: (p1,p2,p3){
          return Center(
            child: Text(p2),
          );
        },
      ),
    );
  }
}
