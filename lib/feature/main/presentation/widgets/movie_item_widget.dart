import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/presentation/pages/movie_info_page.dart';
import 'package:brain_box/feature/words/presentation/manager/words_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../words/presentation/words_screen.dart';
import '../manager/main/main_bloc.dart';

class MovieItemWidget extends StatefulWidget {
  final Content movie;
  final MainBloc bloc;
  const MovieItemWidget({super.key,required this.bloc,required this.movie});

  @override
  State<MovieItemWidget> createState() => _MovieItemWidgetState();
}

class _MovieItemWidgetState extends State<MovieItemWidget> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.movie.isBought??false){
          context.read<WordsBloc>().add(GetMovieInfoEvent(id: widget.movie.id!));
          Navigator.push(context, MaterialPageRoute(builder: (builder)=> WordsScreen(movieId: widget.movie.id,title: widget.movie.name,)));
        }else{
          Navigator.push(context, CupertinoPageRoute(builder: (builder)=> MovieInfoPage(movie: widget.movie),));
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
                height: 250,
                width: 180,
                child: Hero(
                  tag: widget.movie.id??-1,
                    transitionOnUserGestures: true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
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
                              child: Text(widget.movie.belongAge.toString()),
                            ),
                          ),
                        )
                      ],
                    ),
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
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 23
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,top: 3),
                child: AutoSizeText(
                  widget.movie.level??'level error',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(

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
