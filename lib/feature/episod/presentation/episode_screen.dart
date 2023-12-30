import 'package:brain_box/core/constants/icons.dart';
import 'package:brain_box/feature/episod/presentation/widgets/movie_grid_item.dart';
import 'package:brain_box/feature/main/data/models/movie_category.dart';
import 'package:brain_box/feature/main/data/models/movie_item.dart';
import 'package:flutter/material.dart';

class EpisodeScreen extends StatefulWidget {
  const EpisodeScreen({super.key});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {


  List<MovieCategory> movies = [
    MovieCategory(
        type: 'Beginner',
        movies: [
          Movie(title: 'Punched ', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/41/a3/13/41a313bb80e875a4ae3edb61243bcaed.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Wish', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/9b/9b/f8/9b9bf8a998169535e5e18cbea9ce780f.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Elemental', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/fc/8d/e8/fc8de8194a1b1f9239eb61cee6833ea0.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Oppenheimer', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/21/da/f1/21daf1af175109cd9d6064fd13514b5e.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Luca', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/84/fb/56/84fb56005cd90724e9a1e9500b905915.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Joker', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/99/f8/70/99f8702093bd74454c4636a33f558c4a.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Home Alone', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/f7/70/d6/f770d6b297c92d2a8de5a28922e42d80.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'The Grinch', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/7c/90/2a/7c902acb57b1b862e71ece0aea4b8fce.jpg', level: 'Beginner', plus: '16+'),
        ]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Alone'),
        actions: [
          const Text('300',style: TextStyle(fontSize: 17),),
          Image.asset(AppIcons.coin),
          IconButton(onPressed: (){

          },icon: const Icon(Icons.settings)),
        ],
      ),
      body: GridView.builder(
        physics: const ScrollBehavior().getScrollPhysics(context),
        itemCount: movies[0].movies.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3,mainAxisExtent: 300,),
        itemBuilder: (BuildContext context, int index) {
          return MovieGridItem(movie: movies[0].movies[index]);
        },
      )
    );
  }
}
