import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/feature/episod/presentation/episode_screen.dart';
import 'package:brain_box/feature/main/data/models/movie_item.dart';
import 'package:flutter/material.dart';

class MovieItemWidget extends StatelessWidget {
  Movie movie;
  MovieItemWidget({super.key,required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const EpisodeScreen(),));
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
                          image: NetworkImage(movie.imageUrl),
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
                              child: Text(movie.plus),
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
                      movie.title,
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
                    movie.level,
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
