import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/feature/settings/presentation/manager/theme/app_theme_bloc.dart';
import 'package:brain_box/feature/settings/presentation/pages/about_page.dart';
import 'package:brain_box/feature/settings/presentation/pages/help_page.dart';
import 'package:brain_box/feature/settings/presentation/pages/saved_words_page.dart';
import 'package:brain_box/feature/settings/presentation/pages/shop_page.dart';
import 'package:brain_box/feature/settings/presentation/widgets/settings_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/icons.dart';
import '../../../core/utils/background_controller.dart';
import '../data/models/user.dart';
import 'manager/settings/settings_bloc.dart';
import 'package:in_app_review/in_app_review.dart';



class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  User? user;
  ValueNotifier<bool> themeMode = ValueNotifier(false);
  ValueNotifier<bool> appSound = ValueNotifier(false);
  ValueNotifier<bool> isInit = ValueNotifier(false);
  ValueNotifier<String> appLanguage = ValueNotifier('En');
  bool isPremium = false;
  ValueNotifier<PermissionStatus> statusNotification = ValueNotifier(PermissionStatus.denied);
  late SettingsBloc bloc;
  int _selectedFruit = 0;
  final double _kItemExtent = 32.0;
  final List<String> _fruitNames = <String>[
    'Русский',
    'English',
    'Uzbek',
  ];

  final InAppReview inAppReview = InAppReview.instance;

  void showRateDialog() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      // The in-app review dialog is not available.
      // Consider directing the user to the app's listing on Google Play
      const url = 'https://play.google.com/store/apps/details?id=com.aladdin.brain_box';
      // You can use the url_launcher package to launch the URL
      if (await canLaunch(url)) {
        await launch(url);
      }
    }
  }

  @override
  void initState() {
    appLanguage.value = StorageRepository.getString(StoreKeys.appLang);
    themeMode.value = StorageRepository.getBool(StoreKeys.appTheme);
    appSound.value = StorageRepository.getBool(StoreKeys.appSound);
    bloc = SettingsBloc();


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
      create: (context) => bloc..add(GetUserDataEvent(onSuccess: (userData){
        isInit.value = true;
        user = userData;
        Locale currentLocale = context.locale;

        // Access the language code (e.g., 'en', 'ru', 'fr')
        String languageCode = currentLocale.languageCode;

        if(languageCode=='uz'){
          _selectedFruit = 2;
        }else if(languageCode=='en'){
          _selectedFruit = 1;
        }else{
          _selectedFruit = 0;
        }

        setState(() {
          isPremium = user!.isPremium??false;
        });
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
              isPremium ? FittedBox(
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
              ) :  AutoSizeText(
                'Brainbox',
                style: GoogleFonts.kronaOne(),
              )
            ],
          ),
          actions: isPremium ? [] : [
            ValueListenableBuilder(
                valueListenable: isInit,
                builder: (p1,p2,p3) {
                  return p2 ? Text(user!.coins.toString(),style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),) : const SizedBox();
                }
            ),
            IconButton(icon: const Icon(Icons.add_circle),onPressed: () async{
              if(user!=null){
                bool isPaymentAvailable = await Navigator.push(context, MaterialPageRoute(builder: (builder)=>ShopPage(bloc: bloc,user: user!,)));
                if(isPaymentAvailable){
                  bloc.add(GetUserDataEvent(onSuccess: (userData){
                    isInit.value = true;
                    user = userData;
                    setState(() {
                      isPremium = user!.isPremium??false;
                    });
                  }));
                }
              }
            },),
            const SizedBox(width: 12,),
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
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            foregroundImage: CachedNetworkImageProvider(
                              user!.imageUrl??'',

                            ),
                          ),
                        )
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Text(
                        user!.name??'Abullajon',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Text(
                        user!.email??'adbullajon@gmail.com',
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
                          click: (){
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder: (BuildContext context) => Container(
                                height: 216,
                                padding: const EdgeInsets.only(top: 6.0),
                                // The Bottom margin is provided to align the popup above the system navigation bar.
                                margin: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),
                                // Provide a background color for the popup.
                                color: CupertinoColors.systemBackground.resolveFrom(context),
                                // Use a SafeArea widget to avoid system overlaps.
                                child: SafeArea(
                                  top: false,
                                  child: CupertinoPicker(
                                    magnification: 1.22,
                                    squeeze: 1.2,
                                    useMagnifier: true,
                                    itemExtent: _kItemExtent,
                                    scrollController: FixedExtentScrollController(
                                      initialItem: _selectedFruit,
                                    ),
                                    onSelectedItemChanged: (int selectedItem) {
                                      setState(() {
                                        _selectedFruit = selectedItem;
                                      });
                                    },
                                    children: List<Widget>.generate(_fruitNames.length, (int index) {
                                      return Center(child: Text(_fruitNames[index]));
                                    }),
                                  ),
                                ),
                              ),
                            ).then((value) => {
                              if(_selectedFruit==0){
                                context.setLocale(const Locale('ru','RU')),
                              }else if(_selectedFruit==1){
                                context.setLocale(const Locale('en','US')),
                              }else{
                                context.setLocale(const Locale('uz','UZ')),
                              }
                            });
                          },
                          title: 'Language'.tr(),
                          action: ValueListenableBuilder(
                            valueListenable: appLanguage,
                            builder: (p1,p2,p3) {
                              return Text(p2,style: const TextStyle(fontWeight: FontWeight.bold),);
                            }
                          ),
                        ),
                        BlocBuilder<AppThemeBloc, AppThemeState>(
                          builder: (context, state) {
                            return SettingsItem(
                              title: 'Night mode'.tr(),
                              action: ValueListenableBuilder(
                              valueListenable: themeMode,
                              builder: (p1,p2,p3){
                                return Switch(value: p2, onChanged: (value){
                                  StorageRepository.putBool(key: StoreKeys.appTheme, value: value);
                                  state.switchValue ? context.read<AppThemeBloc>().add(SwitchOffThemeEven()) : context.read<AppThemeBloc>().add(SwitchOnThemeEven());
                                  themeMode.value=value;
                                });
                              },
                            )
                          );
                        },
                        ),
                        ValueListenableBuilder(
                          valueListenable: statusNotification,
                          builder: (p1,p2,p3) {
                            return p2 == PermissionStatus.granted ? SettingsItem(
                                title: 'App sound'.tr(),
                                action: ValueListenableBuilder(
                                  valueListenable: appSound,
                                  builder: (p1,p2,p3){
                                    return Switch(value: p2, onChanged: (value){ StorageRepository.putBool(key: StoreKeys.appSound, value: value);appSound.value=value; });
                                  },
                                )
                            ) : p2 == PermissionStatus.permanentlyDenied || p2 == PermissionStatus.denied ? SettingsItem(
                                title: 'Permission is denied'.tr(),
                              action: ElevatedButton(
                                onPressed: () {openAppSettings();},
                                child: Text('Go settings'.tr()),
                              ),
                            ) : SettingsItem(title: 'Something went wrong !'.tr());
                          }
                        ),
                        SettingsItem(title: 'Saved words'.tr(),screen: const SavedWordsPage(),),
                        SettingsItem(title: 'Help'.tr(),screen: const HelpPage(),),
                        SettingsItem(title: 'About'.tr(),screen: const AboutPage(),),
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
                            showRateDialog();
                            StorageRepository.putDouble(StoreKeys.rating, rating);
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20,)),
                  ],
                ),
              );
            }
            return CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 65, // Half of width and height of SizedBox
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 30,)),
                SliverToBoxAdapter(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 70,
                      height: 50,
                      color: Colors.white,
                    ),
                  ), // For user name
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 30,),
                ),
                SliverToBoxAdapter(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 10,
                      height: 50,
                      color: Colors.white,
                    ),
                  ), // For user email
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 20,),
                ),
                SliverToBoxAdapter(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 10,
                      height: 50,
                      color: Colors.white,
                    ),
                  ), // For user email
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 20,),
                ),
                SliverToBoxAdapter(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 10,
                      height: 50,
                      color: Colors.white,
                    ),
                  ), // For user email
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 20,),
                ),
                SliverToBoxAdapter(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 10,
                      height: 50,
                      color: Colors.white,
                    ),
                  ), // For user email
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 20,),
                ),
                SliverToBoxAdapter(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 10,
                      height: 50,
                      color: Colors.white,
                    ),
                  ), // For user email
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                // Repeat for other items like SettingsItem, RatingBar, etc.
              ],
            );
          },
        ),
      ),
    );
  }

}
