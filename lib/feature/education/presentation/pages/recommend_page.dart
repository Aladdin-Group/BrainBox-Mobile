import 'package:brain_box/feature/education/presentation/manager/education_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class RecommendPage extends StatefulWidget {
  final EducationBloc bloc;
  const RecommendPage({super.key,required this.bloc});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {

  @override
  void initState() {
    widget.bloc.add(GetMoreEduItemsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EducationBloc,EducationState>(
          bloc: widget.bloc,
          builder: (context,state){
            if(state.status.isSuccess){
              var list = state.list;

              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (itemBuilder,index){
                    if (index == list.length - 3) {
                      if (state.count > list.length) {
                        context.read<EducationBloc>().add(GetMoreEduItemsEvent());
                      }
                    }
                    return Container(
                      padding: const EdgeInsets.all(15),
                      width: double.maxFinite,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(image: CachedNetworkImageProvider(list[index].imageLink??''))
                      ),
                    );
                  }
              );
            }
            if(state.status.isFailure){
              return const Center(
                child: Text('Something went wrong !'),
              );
            }
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
      ),
    );
  }
}
