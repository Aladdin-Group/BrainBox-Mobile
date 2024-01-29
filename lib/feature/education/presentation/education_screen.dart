import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/core/assets/constants/icons.dart';
import 'package:brain_box/feature/education/data/models/edu_main_model.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/education/presentation/pages/essentials_book_page.dart';
import 'package:brain_box/feature/education/presentation/pages/recommend_page.dart';
import 'package:brain_box/feature/main/presentation/manager/main/main_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  List<EduMainModel> list = [];

  @override
  void initState() {
    context.read<EducationBloc>().add(GetEduItemsEvent());
    list.addAll([
      // todo change page value from widget to string for navigate
      EduMainModel(page: const EssentialsBookPage(), title: 'Learn more vocabulary ', image: AppImages.essentialBanner),
      EduMainModel(page: const RecommendPage(), title: 'Learn English with movies ', image: AppImages.cinemaBanner),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          SizedBox(width: 35, height: 35, child: Image.asset(AppIcons.brain)),
          const SizedBox(
            width: 10,
          ),
          (context.read<MainBloc>().state.user?.isPremium ?? false)
              ? FittedBox(
                  child: Row(
                    children: [
                      AutoSizeText(
                        'Brainbox',
                        style: GoogleFonts.kronaOne(),
                      ),
                      AutoSizeText(
                        LocaleKeys.premium.tr(),
                        style: GoogleFonts.kronaOne(),
                      ),
                    ],
                  ),
                )
              : AutoSizeText(
                  'Brainbox',
                  style: GoogleFonts.kronaOne(),
                )
        ],
      )),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => list[index].page));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 240,
                width: double.maxFinite,
                child: Column(
                  children: [
                    Container(
                      height: 200,

                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(image: AssetImage(list[index].image), fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    Text(
                      list[index].title,
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
