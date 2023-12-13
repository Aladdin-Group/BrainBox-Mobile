import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/feature/settings/presentation/pages/about_page.dart';
import 'package:brain_box/feature/settings/presentation/pages/help_page.dart';
import 'package:brain_box/feature/settings/presentation/pages/saved_words_page.dart';
import 'package:brain_box/feature/settings/presentation/widgets/settings_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/constants/icons.dart';
import '../data/models/user.dart';
import 'manager/settings/settings_bloc.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late User user;
  ValueNotifier<bool> themeMode = ValueNotifier(false);
  ValueNotifier<bool> appSound = ValueNotifier(false);
  ValueNotifier<String> appLanguage = ValueNotifier('En');
  ValueNotifier<PermissionStatus> statusNotification = ValueNotifier(PermissionStatus.denied);


  @override
  void initState() {
    appLanguage.value = StorageRepository.getString(StoreKeys.appLang);
    themeMode.value = StorageRepository.getBool(StoreKeys.appTheme);
    appSound.value = StorageRepository.getBool(StoreKeys.appSound);
    checkPermissions();
    super.initState();
  }

  Future<PermissionStatus> checkPermissions() async{
    await Permission.notification.request();
    statusNotification.value = await Permission.notification.status;
    return await Permission.notification.status;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc()..add(GetUserDataEvent(onSuccess: (userData){
        user = userData;
      })),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                  width: 35, height: 35, child: Image.asset(AppIcons.brain)),
              const SizedBox(
                width: 10,
              ),
              AutoSizeText(
                'Brainbox',
                style: GoogleFonts.kronaOne(),
              )
            ],
          ),
          actions: [

          ],
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if(state.status.isSuccess){
              return SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        width: 130,
                        height: 130,
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              user.imageUrl??'',
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Text(
                        user.name??'Abullajon',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Text(
                        user.email??'adbullajon@gmail.com',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SliverList.list(
                      children: [
                        SettingsItem(
                          title: 'Language',
                          action: ValueListenableBuilder(
                            valueListenable: appLanguage,
                            builder: (p1,p2,p3) {
                              return Text(p2,style: const TextStyle(fontWeight: FontWeight.bold),);
                            }
                          ),
                        ),
                        SettingsItem(
                          title: 'Night mode',
                          action: ValueListenableBuilder(
                            valueListenable: themeMode,
                            builder: (p1,p2,p3){
                              return Switch(value: p2, onChanged: (value){
                                StorageRepository.putBool(key: StoreKeys.appTheme, value: value);
                                themeMode.value=value;
                              });
                            },
                          )
                        ),
                        ValueListenableBuilder(
                          valueListenable: statusNotification,
                          builder: (p1,p2,p3) {
                            return p2 == PermissionStatus.granted ? SettingsItem(
                                title: 'App sound',
                                action: ValueListenableBuilder(
                                  valueListenable: appSound,
                                  builder: (p1,p2,p3){
                                    return Switch(value: p2, onChanged: (value){StorageRepository.putBool(key: StoreKeys.appSound, value: value);appSound.value=value;});
                                  },
                                )
                            ) : p2 == PermissionStatus.permanentlyDenied || p2 == PermissionStatus.denied ? SettingsItem(
                                title: 'Permission is denied',
                              action: ElevatedButton(
                                onPressed: () {openAppSettings();},
                                child: const Text('Go settings'),
                              ),
                            ) : SettingsItem(title: 'Something went wrong !');
                          }
                        ),
                        SettingsItem(title: 'Saved words',screen: const SavedWordsPage(),),
                        SettingsItem(title: 'Help',screen: const HelpPage(),),
                        SettingsItem(title: 'About',screen: const AboutPage(),),
                      ],
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Rate the app',style: TextStyle(fontSize: 23),textAlign: TextAlign.center,),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.center,
                        child: RatingBar.builder(
                          initialRating: StorageRepository.getDouble(StoreKeys.rating),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            StorageRepository.putDouble(StoreKeys.rating, rating);
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 20,)),
                  ],
                ),
              );
            }
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
        ),
      ),
    );
  }
}
