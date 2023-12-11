import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/feature/episod/presentation/episode_screen.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieItemWidget extends StatelessWidget {
  Content movie;
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
                          image: CachedNetworkImageProvider(
                              movie?.avatarUrl??'',
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
                              child: Text(movie?.belongAge.toString()??''),
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
                      movie?.name??'error name',
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
                    movie?.level??'level error',
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
