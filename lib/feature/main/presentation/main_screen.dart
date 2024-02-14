import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/assets/constants/app_constants.dart';
import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/core/route/ruotes.dart';
import 'package:brain_box/feature/main/presentation/pages/search_page.dart';
import 'package:brain_box/feature/main/presentation/widgets/movie_item_widget.dart';
import 'package:brain_box/feature/notification/presentation/manager/local_notification_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:feedback_sentry/feedback_sentry.dart';

import '../../../core/assets/constants/icons.dart';
import '../../../core/singletons/storage/storage_repository.dart';
import '../../auth/presentation/auth_screen.dart';
import 'manager/main/main_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    initializeLocalNotifications();
  }

  Future<void> initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {

      },
    );
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: initializationSettingsDarwin,
            android: initializationSettingsAndroid
        );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                CupertinoIcons.arrow_down_to_line,
                size: 70,
                color: Color.fromARGB(255, 10, 175, 196),
              ), // Ensure you have this image in your assets
              const Gap(20),
              Text(
                LocaleKeys.readyToUpdate.tr(),
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 10, 175, 196)),
              ),
              const Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  LocaleKeys.excitingNewVersionAvailableUpdateNow.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ),
              const Gap(30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 10, 175, 196),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(LocaleKeys.updateNow.tr(), style: const TextStyle(fontSize: 20, color: Colors.white)),
                onPressed: () => InAppUpdate.performImmediateUpdate(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkForUpdates(BuildContext context) async {
    final updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      if (!context.mounted) return;
      showUpdateBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalNotificationBloc, LocalNotificationState>(
      listener: (context, state) async {
        final String lastNotificationId = StorageRepository.getString(AppConstants.LAST_NOTIFICATION_ID);

        if (state.lastNotificationId != null && state.lastNotificationId?.id.toString() != lastNotificationId) {
          await StorageRepository.putString(AppConstants.LAST_NOTIFICATION_ID, state.lastNotificationId!.id.toString());
          if (!context.mounted) return;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(LocaleKeys.notifications.tr()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      state.lastNotificationId?.imageUrl ?? '',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.notFound,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    const Gap(12),
                    Text(state.lastNotificationId!.body),
                    const Gap(12),
                    FilledButton(
                        onPressed: () {
                          context.pop();
                          context.pushNamed(RouteNames.notifications);
                        },
                        child: Text(LocaleKeys.learnMore.tr())),
                  ],
                ),
              );
            },
          );
        }
      },
      child: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     context.read<MainBloc>().add(GetAllMoviesEvent());
          //   },
          // ),
          appBar: AppBar(
            title: Row(
              children: [
                SizedBox(width: 35, height: 35, child: Image.asset(AppIcons.brain)),
                const SizedBox(
                  width: 10,
                ),
                (context.read<MainBloc>().state.user?.isPremium ?? false)
                    ? FittedBox(
                        child: Row(
                          children: [
                            AutoSizeText(
                              'Brainbox',
                              style: GoogleFonts.kronaOne(),
                            ),
                            // AutoSizeText(
                            //   LocaleKeys.premium.tr(),
                            //   style: GoogleFonts.kronaOne(),
                            // ),
                          ],
                        ),
                      )
                    : AutoSizeText(
                        'Brainbox',
                        style: GoogleFonts.kronaOne(),
                      )
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    context.pushNamed(RouteNames.notifications);
                  },
                  icon: const Icon(Icons.notifications)),
              IconButton(
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const SearchPage()));
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          body: BlocConsumer<MainBloc, MainState>(
            listener: (context, state) {
              if (state.status.isInProgress) {}
              if (state.status.isSuccess) {}
              if (state.status.isFailure) {}
              if (state.getUserInfoStatus.isInProgress) {}
              if (state.getUserInfoStatus.isSuccess) {
                if(Platform.isAndroid){
                  checkForUpdates(context);
                }
              }
              if (state.getUserInfoStatus.isFailure) {
                context.pushAndRemoveUntil(const AuthScreen());
              }
              if (state.getAllMoviesStatus.isInProgress) {}
              if (state.getAllMoviesStatus.isSuccess) {}
              if (state.getAllMoviesStatus.isFailure) {}
            },
            builder: (context, state) {
              var movie = state.movies;
              if (state.status.isInProgress) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10, // Number of shimmer category items
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 20),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const SkeletonShimmer(height: 30, width: 150),
                          ),
                        ),
                        SizedBox(
                          height: 270,
                          width: double.maxFinite,
                          child: ListView.separated(
                              // padding: const EdgeInsets.symmetric(horizontal: 10),
                              itemCount: 5,
                              // Number of shimmer movies in each category
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              itemBuilder: (context, index) {
                                return const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonShimmer(height: 200, width: 170),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Gap(8),
                                          SkeletonShimmer(height: 30, width: 150),
                                          Gap(8),
                                          SkeletonShimmer(height: 20, width: 120),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                                // return Shimmer.fromColors(
                                //   baseColor: Colors.grey[300]!,
                                //   highlightColor: Colors.grey[100]!,
                                //   child: Container(
                                //     width: 200, // Approximate width of a movie item
                                //     height: 270,
                                //     margin: const EdgeInsets.symmetric(horizontal: 10),
                                //     color: Colors.white,
                                //   ),
                                // );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const Gap(20);
                              }),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Gap(10);
                  },
                );
              }
              if (state.movies.isEmpty) {
                return Center(
                  child: Text(LocaleKeys.sorryBaseIsEmpty.tr()),
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        // prototypeItem: Text('data'),
                        itemCount: movie.length,
                        itemBuilder: (context, index) {
                          String key = state.movies.keys.elementAt(index);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 10),
                                child: Text(
                                  key,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 320,
                                width: double.maxFinite,
                                child: ListView.builder(
                                    itemCount: state.movies[key]?.listData.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, hor) {
                                      // return Text("${state.movies[key]?.listData.length}");
                                      // print("${state.movies[key]?.length}length");
                                      // var movieIndex = 0;
                                      // for (var i = 0; i < state.count.length; i++) {
                                      //   if (state.count[i].keys.first == key) {
                                      //     movieIndex = i;
                                      //     break;
                                      //   }
                                      // }
                                      if (hor == state.movies[key]!.listData.length - 1) {
                                        context.read<MainBloc>().add(GetMoreMovieEvent(
                                            movieLevel: key,
                                            onSuccess: () {
                                              setState(() {});
                                            }));
                                      }
                                      return MovieItemWidget(
                                        movie: state.movies[key]!.listData[hor],
                                        bloc: context.read<MainBloc>(),
                                      );
                                    }),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                );
              }
            },
          )),
    );
  }
}

class SkeletonShimmer extends StatelessWidget {
  const SkeletonShimmer({
    super.key,
    required this.height,
    required this.width,
    this.radius = 16,
    this.margin = 0,
  });

  final double height;
  final double width;
  final double radius;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: margin),
        height: height,
        width: width,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }
}
