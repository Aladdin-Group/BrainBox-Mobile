import 'package:brain_box/feature/lang/presentation/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/navigation_bloc.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings){
    final NavigationBloc bloc = NavigationBloc();
    final args = settings.arguments;
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => BlocProvider<NavigationBloc>.value(value: bloc,child: const LanguageScreen(),),);
      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return const Scaffold(
        body: Center(
          child: Text('Something went wrong!'),
        ),
      );
    });
  }
}