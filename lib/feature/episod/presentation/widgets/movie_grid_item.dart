import 'package:brain_box/feature/main/data/models/movie_item.dart';
import 'package:brain_box/feature/words/presentation/words_screen.dart';
import 'package:flutter/material.dart';

class MovieGridItem extends StatelessWidget {
  final Movie movie;
  const MovieGridItem({super.key,required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(allowSnapshotting: false, builder: (context) => WordsScreen(),));
      },
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      movie.imageUrl,fit: BoxFit.cover,),
                  )
              ),
              Text(
                movie.title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(movie.description)
            ],
          ),
        ),
      ),
    );
  }
}
