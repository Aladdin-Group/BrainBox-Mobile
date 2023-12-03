import 'package:brain_box/feature/lang/presentation/language_screen.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/singletons/storage/storage_repository.dart';
import '../../../core/singletons/storage/store_keys.dart';
import '../../navigation/presentation/pages/lading_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late NavigationBloc navigationBloc;

  @override
  void initState() {
    super.initState();
    navigationBloc = NavigationBloc();
    route(context);
  }

  Future route(BuildContext context)async{
    await Future.delayed(const Duration(milliseconds: 20),() {
      bool isAuth = StorageRepository.getBool(StoreKeys.isAuth) || StorageRepository.getBool(StoreKeys.isSkip);
      if(!isAuth){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LanguageScreen(),),(route) => false,);
      }else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:  (context) =>  BlocProvider<NavigationBloc>.value(value: navigationBloc,child: const LadingPage(),),),(route) => false,);
      }
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 175, 196),
      body: Center(
        child: Image.asset('assets/icons/brain.png'),
      ),
    );
  }
}
