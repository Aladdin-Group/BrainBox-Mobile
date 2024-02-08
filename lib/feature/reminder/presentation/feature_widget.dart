import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/assets/constants/colors.dart';

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String about;
  const FeatureItem({super.key,required this.icon,required this.title,required this.about});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,top: 40),
      child: SizedBox(
        height: 85,
        width: double.maxFinite,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 15),
              child: Icon(
                  icon,
                size: 65,
                color: AppColors.main,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      title,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Gap(2),
                  Expanded(child: AutoSizeText(about,style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 15,),))
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
