import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/feature/auth/presentation/auth_screen.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/assets/constants/icons.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  void _chooseAndAuth(String la,String ng,BuildContext context) async{
    context.setLocale(Locale(la,ng));
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              width: double.maxFinite,
              height: 220,
              child: Image.asset(AppIcons.brain)
          ),
          AutoSizeText(
              'BrainBox',
            textAlign: TextAlign.center,
            style: GoogleFonts.kronaOne(
              fontSize: 35
            ),
          ),
          const SizedBox(height: 75,),
          AutoSizeText(
              LocaleKeys.chooseAppLang.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30,left: 20,right: 20),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: ()async{
                  _chooseAndAuth('en','US',context);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )
                    )
                ),
                child: const Text(
                  'English',
                  style: TextStyle(
                      fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: ()async{
                  _chooseAndAuth('ru','RU',context);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )
                    )
                ),
                child: const Text(
                  'Русский',
                  style: TextStyle(
                      fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15,left: 20,right: 20),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: ()async{
                  _chooseAndAuth('uz','UZ',context);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        )
                    )
                ),
                child: const Text(
                  'O\'zbekcha',
                  style: TextStyle(
                      fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
