import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/feature/main/data/models/movie_availbility.dart';
import 'package:brain_box/feature/main/data/models/search_model.dart';
import 'package:brain_box/feature/main/presentation/manager/main/main_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../words/presentation/words_screen.dart';

class SearchPage extends StatefulWidget {
  final MainBloc bloc;
  const SearchPage({super.key,required this.bloc});

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
              padding: const EdgeInsets.all(8.0),
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
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
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
                      if(listSearch.length==index){
                        return SizedBox(
                          height: 90,
                          child: CupertinoButton(
                              onPressed: (){
                                print('click');
                                widget.bloc.add(SubmitMovieEvent(movieName: searchController.text));
                              },
                              child: Text('Request movie'.tr())
                          ),
                        );
                      }
                      return ListTile(
                        onTap: (){
                          if(listSearch[index].isBought??false){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WordsScreen(movieId: listSearch[index].id!.toInt(),),));
                          }else{
                            widget.bloc.add(GetUserInfoEvent(
                                success: (user){
                                  if(user.isPremium??false){
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WordsScreen(movieId: listSearch[index].id!.toInt(),),));
                                  }else{
                                    if((user.coins??0)>(listSearch[index].price??0)){
                                      Navigator.pop(context);
                                      showModalBottomSheet(
                                          context: context, builder: (builder)=>Container(
                                        width: double.maxFinite,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)
                                            )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    height: 200,
                                                    width: 170,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(15),
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: CachedNetworkImageProvider(
                                                              listSearch[index].avatarUrl??'',
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Text('Forcoins'.tr(args: ['${listSearch[index].price}',])),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SizedBox(
                                                        width: 200,
                                                        child: FittedBox(
                                                          child: AutoSizeText(
                                                            listSearch[index].name??'NULL',
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20
                                                            ),
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 210,
                                                      height: 170,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 10.0),
                                                        child: AutoSizeText(
                                                          listSearch[index].description??'NULL',
                                                          maxLines: 10,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(onPressed: (){ Navigator.pop(context); }, child: const Text('Cancel')),
                                                )),
                                                Expanded(child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(onPressed: (){

                                                    widget.bloc.add(BuyMovieEvent(success: (success){
                                                      Navigator.pop(context);
                                                      // listSearch[index].isBought = true;
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => WordsScreen(movieId: listSearch[index].id!.toInt(),),));
                                                    }, failure: (){
                                                      Navigator.pop(context);
                                                      showDialog(context: context, builder: (builder)=>AlertDialog(title: Text('Something went wrong'.tr()),));
                                                    }, progress: (){
                                                      Navigator.pop(context);
                                                      showDialog(context: context, builder: (builder)=>const AlertDialog(title: CupertinoActivityIndicator(),));
                                                    }, movieId: listSearch[index].id!.toInt()??-1));

                                                  }, child: Text('Purchase'.tr())),
                                                )),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                      );
                                    }else{
                                      Navigator.pop(context);
                                      showDialog(context: context, builder: (context)=>AlertDialog(title: Text('Wrong'.tr()),content: Text('You dont have enough coins for this movie!'.tr()),));
                                    }
                                  }
                                },
                                failure: (){
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (builder)=> AlertDialog(title: Text('Something went wrong'.tr()),));
                                },
                                progress: (){
                                  showDialog(context: context, builder: (builder)=>const AlertDialog(title: CupertinoActivityIndicator(),));
                                }
                            ));
                          }
                        },
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
                          widget.bloc.add(SubmitMovieEvent(movieName: searchController.text));
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
