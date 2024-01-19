import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/exceptions/exception.dart';
import 'package:brain_box/feature/main/presentation/pages/search_page.dart';
import 'package:brain_box/feature/main/presentation/widgets/movie_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/assets/constants/icons.dart';
import '../../../core/singletons/storage/storage_repository.dart';
import '../../../core/singletons/storage/store_keys.dart';
import '../../auth/presentation/auth_screen.dart';
import '../../settings/data/models/user.dart';
import '../data/models/Movie.dart';
import 'manager/main/main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  SearchController searchController = SearchController();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var index = 0;
  final hive = Hive.box(StoreKeys.userData);
  User? user;
  late MainBloc bloc;


  @override
  void initState() {
    super.initState();
    bloc = MainBloc()..add(GetUserInfoEvent(success: (success){
      user = success;
      checkForUpdates(context);
      hive.put(StoreKeys.user, success);
    }, failure: (failure){
      if(failure is UserTokenExpire){
        StorageRepository.deleteBool(StoreKeys.isAuth);
        StorageRepository.deleteString(StoreKeys.token);
        GoogleSignIn().signOut();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const AuthScreen()), (route) => false);
      }
    }, progress: (){}))..add(GetAllMoviesEvent(context: context));
    user = hive.get(StoreKeys.user);
    initializeLocalNotifications();
  }

  Future<void> initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(CupertinoIcons.arrow_down_to_line,size: 70,color: Color.fromARGB(
                  255, 10, 175, 196),), // Ensure you have this image in your assets
              SizedBox(height: 20),
              Text(
                'Ready to Update!'.tr(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(
                    255, 10, 175, 196)),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'An exciting new version of the app is available. Update now to enjoy the latest features and improvements!'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(
                      255, 10, 175, 196),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text('Update Now'.tr(), style: TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () {
                  InAppUpdate.performImmediateUpdate().catchError((e) => print(e.toString()));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkForUpdates(BuildContext context) async {
    final updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability==UpdateAvailability.updateAvailable) {
      showUpdateBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (context) => bloc,
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                SizedBox(
                    width: 35, height: 35, child: Image.asset(AppIcons.brain)),
                const SizedBox(
                  width: 10,
                ),
                (user?.isPremium??false) ? FittedBox(
                  child: Row(
                    children: [
                      AutoSizeText(
                        'Brainbox',
                        style: GoogleFonts.kronaOne(),
                      ),
                      AutoSizeText(
                        'Premium'.tr(),
                        style: GoogleFonts.kronaOne(),
                      ),
                    ],
                  ),
                ) : AutoSizeText(
                  'Brainbox',
                  style: GoogleFonts.kronaOne(),
                )
              ],
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                      onPressed: () async{
                        Navigator.push(context, MaterialPageRoute(builder: (builder)=> SearchPage(bloc: context.read<MainBloc>())));
                      },
                      icon: const Icon(Icons.search)),
                ],
              )
            ],
          ),
          body: BlocConsumer<MainBloc, MainState>(
            listener: (context, state) {

            },
            builder: (context, state) {
              if(state.status.isSuccess){
                var movie = state.movies;
                if(state.movies.isEmpty){
                  return Center(
                    child: Text('Sorry base is empty'.tr()),
                  );
                }else{
                  return SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            // prototypeItem: Text('data'),
                            itemCount: movie.length,
                            itemBuilder: (context, index) {
                              String key = state.movies.keys.elementAt(index);
                              List<Content> movies = state.movies[key] ?? [];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 10, bottom: 10),
                                    child: Text(
                                      key,
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 270,
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                        itemCount: movies.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, hor) {
                                          var movieIndex = 0;
                                          for(var i = 0; i < state.count.length; i++){
                                            if(state.count[i].keys.first==key){
                                              movieIndex=i;
                                              break;
                                            }
                                          }
                                          if (hor == movies.length - 1) {
                                            if (state.count[movieIndex][key]! > movies.length) {
                                              context.read<MainBloc>().add(GetMoreMovieEvent(movieLevel: key, onSuccess: (onSuccess){
                                                setState(() {
                                                },);
                                              },context: context));
                                            }
                                          }else{
                                          }
                                          return  MovieItemWidget(movie: movies[hor],bloc: context.read<MainBloc>(),);
                                        }
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
              }
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10, // Number of shimmer category items
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
                          child: Container(
                            width: 150,
                            height: 25,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 270,
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: 5, // Number of shimmer movies in each category
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 200, // Approximate width of a movie item
                                  height: 270,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
            },
          )),
    );
  }
}
