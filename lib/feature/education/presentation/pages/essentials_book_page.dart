import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/feature/education/presentation/pages/units_page.dart';
import 'package:brain_box/feature/education/presentation/widgets/book_item.dart';
import 'package:flutter/material.dart';

import '../../data/models/book_model.dart';

class EssentialsBookPage extends StatefulWidget {
  final EducationBloc bloc;
  const EssentialsBookPage({super.key,required this.bloc});

  @override
  State<EssentialsBookPage> createState() => _EssentialsBookPageState();
}

class _EssentialsBookPageState extends State<EssentialsBookPage> {

  List<BookModel> list = [];

  @override
  void initState() {
    list.addAll([
      BookModel(essential: Essential.essential_1, image: AppImages.essential_1, name: 'Essential 1'),
      BookModel(essential: Essential.essential_2, image: AppImages.essential_2, name: 'Essential 2'),
      BookModel(essential: Essential.essential_3, image: AppImages.essential_3, name: 'Essential 3'),
      BookModel(essential: Essential.essential_4, image: AppImages.essential_4, name: 'Essential 4'),
      BookModel(essential: Essential.essential_5, image: AppImages.essential_5, name: 'Essential 5'),
      BookModel(essential: Essential.essential_6, image: AppImages.essential_6, name: 'Essential 6'),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 8.0, // Spacing between columns
          mainAxisSpacing: 8.0, // Spacing between rows
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return BookItem(
              model: list[index],
            onClick: (Essential essential){
                Navigator.push(context, MaterialPageRoute(builder: (builder)=> UnitsPage(book: essential,bloc: widget.bloc,)));
            },
          );
        },
      ),
    );
  }
}
