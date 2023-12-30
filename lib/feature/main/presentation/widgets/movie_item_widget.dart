import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../words/presentation/words_screen.dart';
import '../manager/main/main_bloc.dart';

class MovieItemWidget extends StatefulWidget {
  Content movie;
  MainBloc bloc;
  MovieItemWidget({super.key,required this.bloc,required this.movie});

  @override
  State<MovieItemWidget> createState() => _MovieItemWidgetState();
}

class _MovieItemWidgetState extends State<MovieItemWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.movie.isBought??false){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WordsScreen(movieId: widget.movie.id,),));
        }else{
          widget.bloc.add(GetUserInfoEvent(
              success: (user){
                if(user.isPremium??false){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WordsScreen(movieId: widget.movie.id,),));
                }else{
                  if((user.coins??0)>(widget.movie.price??0)){
                    Navigator.pop(context);
                    showModalBottomSheet(
                        context: context, builder: (builder)=>Container(
                      height: 300,
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
                                            widget.movie.avatarUrl??'',
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Forcoins'.tr(args: ['${widget.movie.price}',])),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.movie.name??'NULL',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 210,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text.',
                                        maxLines: 10,
                                        overflow: TextOverflow.clip,
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
                                child: ElevatedButton(onPressed: (){ Navigator.pop(context); }, child: Text('Cancel')),
                              )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(onPressed: (){

                                  widget.bloc.add(BuyMovieEvent(success: (success){
                                    Navigator.pop(context);
                                    widget.movie.isBought = true;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => WordsScreen(movieId: widget.movie.id,),));
                                  }, failure: (){
                                    Navigator.pop(context);
                                    showDialog(context: context, builder: (builder)=>AlertDialog(title: Text('Something went wrong'.tr()),));
                                  }, progress: (){
                                    Navigator.pop(context);
                                    showDialog(context: context, builder: (builder)=>const AlertDialog(title: CupertinoActivityIndicator(),));
                                  }, movieId: widget.movie.id??-1));

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
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Card(
          elevation: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: 170,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          widget.movie.avatarUrl??'',
                        ),
                      )
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Card(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              // color: Colors.white,
                                borderRadius: BorderRadius.circular(100)
                            ),
                            alignment: Alignment.center,
                            child: Text(widget.movie.belongAge.toString()??''),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,top: 8),
                child: SizedBox(
                  width: 170,
                  child: AutoSizeText(
                    widget.movie.name??'error name',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AutoSizeText(
                  widget.movie.level??'level error',
                  style: const TextStyle(
                      fontSize: 13
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
