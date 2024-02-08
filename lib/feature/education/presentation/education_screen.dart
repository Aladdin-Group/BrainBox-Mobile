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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/assets/constants/colors.dart';

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
      EduMainModel(page: const EssentialsBookPage(), title: 'Essential Words 📚', image: AppImages.essentialBanner),
      EduMainModel(page: const RecommendPage(), title: 'Useful YouTube 📺', image: AppImages.cinemaBanner),
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
      body: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: list.length,
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => list[index].page));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                    child: SizedBox(
                      height: 240,
                      width: double.maxFinite,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.grey
                              )
                            ],
                            image: DecorationImage(image: NetworkImage(list[index].image), fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                width: 200,
                                height: 240,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                    colors: [Colors.black45, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                list[index].title,
                                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              width: 80,
              height: 80,
                child:  const Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/564x/a4/64/93/a46493b6ca3d8e3363f61caaa37d9567.jpg',
                    ),
                  ),
                ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Do you have ',style: Theme.of(context).textTheme.bodyLarge,),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.main,
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 2,top: 2),
                          child: Text(
                              'Idea',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(' for this place ?!',style: Theme.of(context).textTheme.bodyLarge,),
                    ],
                  ),
                  Gap(5),
                  GestureDetector(
                    onTap: (){
                      launchUrl(Uri.parse('https://t.me/brainboxxbot'));
                    },
                    child: Text(
                        'Click it.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.blueAccent
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
