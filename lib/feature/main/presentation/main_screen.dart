import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/constants/icons.dart';
import 'package:brain_box/feature/main/presentation/widgets/movie_item_widget.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../search/presentation/search_delegate.dart';
import '../data/models/Movie.dart';
import 'manager/main/main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SearchController searchController = SearchController();
  var index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (context) => MainBloc()..add(GetAllMoviesEvent()),
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                SizedBox(
                    width: 35, height: 35, child: Image.asset(AppIcons.brain)),
                const SizedBox(
                  width: 10,
                ),
                AutoSizeText(
                  'Brainbox',
                  style: GoogleFonts.kronaOne(),
                )
              ],
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: Search(["v1", "v2", "v3"]));
                      },
                      icon: const Icon(Icons.search)),
                ],
              )
            ],
          ),
          body: BlocConsumer<MainBloc, MainState>(
            listener: (context, state) {

            },
            builder: (context, state) {
              var movie = state.movies;
              if(state.status.isSuccess){
                if(state.movies.isEmpty){
                  return const Center(
                    child: Text('Sorry base is empty 😔'),
                  );
                }else{
                  return SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            // prototypeItem: Text('data'),
                            itemCount: movie.length,
                            itemBuilder: (context, index) {
                              String key = state.movies.keys.elementAt(index);
                              List<Content> movies = state.movies[key] ?? [];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 10, bottom: 10),
                                    child: Text(
                                      key,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 270,
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                        itemCount: movies.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, hor) {
                                          var movieIndex = 0;
                                          for(var i = 0; i < state.count.length; i++){
                                            if(state.count[i].keys.first==key){
                                              movieIndex=i;
                                              break;
                                            }
                                          }
                                          if (hor == movies.length - 1) {
                                            if (state.count[movieIndex][key]! > movies.length) {
                                              context.read<MainBloc>().add(GetMoreMovieEvent(movieLevel: key, onSuccess: (onSuccess){
                                                setState(() {
                                                });
                                              }));
                                            }
                                          }else{
                                          }
                                          return  MovieItemWidget(movie: movies[hor]);
                                        }
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
              }else if(state.status.isInProgress){
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            },
          )),
    );
  }
}
