import 'package:brain_box/feature/main/data/models/movie_availbility.dart';
import 'package:brain_box/feature/main/data/models/search_model.dart';
import 'package:brain_box/feature/main/presentation/manager/main/main_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  MainBloc bloc;
  SearchPage({super.key,required this.bloc});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<SearchModel> listSearch = [];
  TextEditingController searchController = TextEditingController();
  bool isOpenDialog = false;
  ValueNotifier<MovieAvailability> isAvailableMovie = ValueNotifier(MovieAvailability.initial);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: searchController,
                onChanged: (value){
                  widget.bloc.add(SearchMovieEvent(success: (success){
                    isAvailableMovie.value = MovieAvailability.have;
                    setState(() {
                      listSearch.clear();
                      listSearch.addAll(success);
                    });
                  }, failure: (){
                    isAvailableMovie.value = MovieAvailability.not;
                  }, keyWord: value));
                },
                decoration: InputDecoration(
                  hintText: 'Search'.tr(),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: isAvailableMovie,
                builder: (context,value,p1) {
                  return value == MovieAvailability.initial ? const Center(child: Text('Search any movie 📽️🍿'),) : value == MovieAvailability.have ? ListView.builder(
                    itemCount: listSearch.length, // Replace with your data length
                    itemBuilder: (context, index) {
                      print(listSearch.length-2==index);
                      print(listSearch.length);
                      print(index-1);
                      if(listSearch.length==index){
                        return SizedBox(
                          height: 90,
                          child: CupertinoButton(
                              onPressed: (){
                                widget.bloc.add(SubmitMovieEvent(movieName: searchController.text));
                              },
                              child: Text('Request movie'.tr())
                          ),
                        );
                      }
                      return ListTile(
                        title: Text(listSearch[index].name??'NULL'), // Replace with your data
                        subtitle: Text(listSearch[index].level??''), // Replace with your data
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(listSearch[index].avatarUrl??'')
                            )
                          ),
                        ), // Replace with your item icon
                      );
                    },
                  ) : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not find,but you can order the movie'.tr()),
                        CupertinoButton(child: const Text('Request'), onPressed: (){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sent your order')));
                        }),
                      ],
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
