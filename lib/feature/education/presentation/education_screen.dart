import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/feature/education/data/models/edu_main_model.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/education/presentation/pages/essentials_book_page.dart';
import 'package:brain_box/feature/education/presentation/pages/recommend_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {

  late EducationBloc bloc;
  List<EduMainModel> list = [];

  @override
  void initState() {
    bloc = EducationBloc()..add(GetEduItemsEvent());
    list.addAll([EduMainModel(page: EssentialsBookPage(bloc: bloc,), title: 'Learn more vocabulary ', image: AppImages.essentialBanner),
      EduMainModel(page: RecommendPage(bloc: bloc,), title: 'Learn English with movies ', image: AppImages.cinemaBanner),]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        body: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=> list[index].page));
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
                            image: DecorationImage(
                                image: AssetImage(list[index].image),
                              fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                        Text(
                            list[index].title,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
        )
      ),
    );
  }
}
