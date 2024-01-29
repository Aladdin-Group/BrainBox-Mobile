import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({
    super.key,
  });

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  @override
  void initState() {
    context.read<EducationBloc>().add(GetMoreEduItemsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.movies.tr())),
      body: BlocBuilder<EducationBloc, EducationState>(builder: (context, state) {
        print(state.list);
        if (state.status.isSuccess) {
          return state.list.isEmpty
              ? Center(child: Text(LocaleKeys.noFoundMovies.tr()))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.list.length,
                  itemBuilder: (itemBuilder, index) {
                    // if (index == state.list.length - 3) {
                    //   if (state.count > state.list.length) {
                    //     context.read<EducationBloc>().add(GetMoreEduItemsEvent());
                    //   }
                    // }
                    final eduModel = state.list[index];
                    print(eduModel.imageLink);
                    return GestureDetector(
                      onTap: () async {
                        if (eduModel.link != null && await canLaunchUrl(Uri.parse(eduModel.link!))) {
                          launchUrl(Uri.parse(eduModel.link!));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: double.maxFinite,
                        height: 200,

                        // child: Column(
                        //   children: [
                        //     if (eduModel.imageLink != null) Image.network(eduModel.imageLink!,height: 100,),
                        //     Text(state.list[index].imageLink ?? 'rasm yo`q'),
                        //   ],
                        // ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(

                              eduModel.imageLink ?? '',
                              maxWidth: 300,
                            ))),
                      ),
                    );
                  });
        }
        if (state.status.isFailure) {
          return const Center(child: Text('Something went wrong !'));
        }
        return const Center(child: CupertinoActivityIndicator());
      }),
    );
  }
}
