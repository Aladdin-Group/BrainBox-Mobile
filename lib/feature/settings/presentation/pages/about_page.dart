import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'.tr()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              LocaleKeys.welcomeToBrainbox.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Text(
              LocaleKeys.yourGatewayToLanguageMasteryThroughTheMagicOfMovies.tr(),
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            const Gap(16),
            Text(
              LocaleKeys.ourMission.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              LocaleKeys.brainboxLangSubsEngageFun
                  .tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const Gap(16),
            Text(
              LocaleKeys.howItWorks.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add bullet points or numbered list for 'How It Works' section
            const Gap(16),
            Text(
              LocaleKeys.chooseYourMovie.tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const Gap(10),
             Text(
              LocaleKeys.pickYourLanguage.tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const Gap(10),
            Text(
              LocaleKeys.learnWithSubtitles.tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const Gap(10),
            Text(
              LocaleKeys.interactiveLearningTools.tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const Gap(10),
            Text(
              LocaleKeys.customizedLearningExperience.tr(),
              style: const TextStyle(fontSize: 16),
            ),
            // ... Continue with other steps
            const Gap(16),
            Text(
              'Why Movies?'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Movies are not just about entertainment; they are cultural snapshots. They provide contextual learning, making it easier to understand idiomatic expressions, slang, and the natural flow of conversation. By learning through movies, you\'re not just memorizing words; you\'re experiencing the language as it\'s spoken by natives in real-life situations.'
                  .tr(),
              style: const TextStyle(fontSize: 16),
            ),
            // ... Add more sections as needed
            const Gap(16),
            Text(
              'Safe and Secure:'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your privacy and online safety are paramount. BrainBox is committed to protecting your data and providing a secure learning environment.'
                  .tr(),
              style: const TextStyle(fontSize: 16),
            ),
            const Gap(16),
            const Text(
              'Join Our Community:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Become part of a global community of language enthusiasts. Share insights, discuss movies, and practice your new language skills with learners from around the world.'
                  .tr(),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
