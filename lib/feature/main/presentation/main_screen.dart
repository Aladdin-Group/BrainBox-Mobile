import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/constants/icons.dart';
import 'package:brain_box/feature/main/data/models/movie_category.dart';
import 'package:brain_box/feature/main/data/models/movie_item.dart';
import 'package:brain_box/feature/main/presentation/widgets/movie_item_widget.dart';
import 'package:brain_box/feature/search/presentation/search_delegate.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  SearchController searchController = SearchController();
  
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
    MovieCategory(
        type: 'Elementary',
        movies: [
          Movie(title: 'Wish', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/9b/9b/f8/9b9bf8a998169535e5e18cbea9ce780f.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Luca', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/84/fb/56/84fb56005cd90724e9a1e9500b905915.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Oppenheimer', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/21/da/f1/21daf1af175109cd9d6064fd13514b5e.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Joker', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/99/f8/70/99f8702093bd74454c4636a33f558c4a.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Punched ', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/41/a3/13/41a313bb80e875a4ae3edb61243bcaed.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'The Grinch', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/7c/90/2a/7c902acb57b1b862e71ece0aea4b8fce.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Home Alone', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/f7/70/d6/f770d6b297c92d2a8de5a28922e42d80.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Elemental', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/fc/8d/e8/fc8de8194a1b1f9239eb61cee6833ea0.jpg', level: 'Beginner', plus: '16+'),
        ]
    ),
    MovieCategory(
        type: 'Elementary',
        movies: [
          Movie(title: 'Joker', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/99/f8/70/99f8702093bd74454c4636a33f558c4a.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'The Grinch', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/7c/90/2a/7c902acb57b1b862e71ece0aea4b8fce.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Luca', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/84/fb/56/84fb56005cd90724e9a1e9500b905915.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Home Alone', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/f7/70/d6/f770d6b297c92d2a8de5a28922e42d80.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Punched ', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/41/a3/13/41a313bb80e875a4ae3edb61243bcaed.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Oppenheimer', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/21/da/f1/21daf1af175109cd9d6064fd13514b5e.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Wish', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/9b/9b/f8/9b9bf8a998169535e5e18cbea9ce780f.jpg', level: 'Beginner', plus: '16+'),
          Movie(title: 'Elemental', description: 'This movie is best!', price: 60, imageUrl: 'https://i.pinimg.com/564x/fc/8d/e8/fc8de8194a1b1f9239eb61cee6833ea0.jpg', level: 'Beginner', plus: '16+'),
        ]
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 35,
                height: 35,
                child: Image.asset(AppIcons.brain)
            ),
            const SizedBox(width: 10,),
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
                  onPressed: (){
                    showSearch(context: context, delegate: Search(["v1","v2","v3"]));
                  },
                  icon: const Icon(Icons.search)
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                // prototypeItem: Text('data'),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return DelayedWidget(
                    delayDuration: Duration(milliseconds: 50),// Not required
                    animationDuration: Duration(seconds: 1),// Not required
                    animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0,top: 10,bottom: 10),
                          child: Text(
                            movies[index].type,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 270,
                          width: double.maxFinite,
                          child: ListView.builder(
                              itemCount: movies[index].movies.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, hor) => MovieItemWidget(movie: movies[index].movies[hor])
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
