import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/route/ruotes.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/feature/auth/presentation/auth_screen.dart';
import 'package:brain_box/feature/settings/data/repositories/language_repo.dart';
import 'package:brain_box/feature/settings/presentation/manager/theme/app_theme_bloc.dart';
import 'package:brain_box/feature/settings/presentation/pages/about_page.dart';
import 'package:brain_box/feature/settings/presentation/pages/help_page.dart';
import 'package:brain_box/feature/settings/presentation/pages/saved_words_page.dart';
import 'package:brain_box/feature/settings/presentation/widgets/settings_item.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/assets/constants/icons.dart';
import 'manager/settings/settings_bloc.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // User? user;
  // ValueNotifier<bool> themeMode = ValueNotifier(false);
  ValueNotifier<bool> appSound = ValueNotifier(false);
  ValueNotifier<bool> isInit = ValueNotifier(false);

  // ValueNotifier<String> appLanguage = ValueNotifier('En');
  bool isPremium = false;
  ValueNotifier<PermissionStatus> statusNotification = ValueNotifier(PermissionStatus.denied);
  late SettingsBloc bloc;

  // int _selectedFruit = 0;
  final double _kItemExtent = 32.0;

  // final List<String> _languages = <String>[
  //   'Русский',
  //   'English',
  //   'Uzbek',
  // ];

  final InAppReview inAppReview = InAppReview.instance;

  void showRateDialog() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      // The in-app review dialog is not available.
      // Consider directing the user to the app's listing on Google Play
      const url = 'https://play.google.com/store/apps/details?id=com.aladdin.brain_box';
      // You can use the url_launcher package to launch the URL
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }
  }

  @override
  void initState() {
    // appLanguage.value = StorageRepository.getString(StoreKeys.appLang);
    // themeMode.value = StorageRepository.getBool(StoreKeys.appTheme);
    appSound.value = StorageRepository.getBool(StoreKeys.appSound);
    bloc = SettingsBloc();

    checkPermissions();
    super.initState();
  }

  Future<PermissionStatus> checkPermissions() async {
    await Permission.notification.request();
    statusNotification.value = await Permission.notification.status;
    return await Permission.notification.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 35, height: 35, child: Image.asset(AppIcons.brain)),
            const SizedBox(
              width: 10,
            ),
            isPremium
                ? FittedBox(
                    child: Row(
                      children: [
                        AutoSizeText(
                          'Brainbox',
                          style: GoogleFonts.kronaOne(),
                        ),
                        AutoSizeText(
                          LocaleKeys.premium.tr(),
                          style: GoogleFonts.kronaOne(),
                        ),
                      ],
                    ),
                  )
                : AutoSizeText(
                    'Brainbox',
                    style: GoogleFonts.kronaOne(),
                  )
          ],
        ),
        actions: isPremium
            ? []
            : [
                ValueListenableBuilder(
                    valueListenable: isInit,
                    builder: (p1, p2, p3) {
                      return p2
                          ? Text(
                              context.read<SettingsBloc>().state.user!.coins.toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : const SizedBox();
                    }),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () async {
                    if (context.read<SettingsBloc>().state.user != null) {
                      context.pushNamed(RouteNames.shopPage);
                      // bool isPaymentAvailable =
                      //     await Navigator.push(context, MaterialPageRoute(builder: (builder) => const ShopPage()));
                      // if (isPaymentAvailable) {
                      // bloc.add(GetUserDataEvent(onSuccess: (userData) {
                      //   isInit.value = true;
                      //   user = userData;
                      //   setState(() {
                      //     isPremium = user!.isPremium ?? false;
                      //   });
                      // }));
                      // }
                    }
                  },
                ),
                const Gap(12),
              ],
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final controller = context.watch<SettingsBloc>().state;
          if (state.status.isSuccess) {
            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: AvatarImage(
                      radius: 50,
                      // backround color random dark color
                      backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)].shade800,
                      backgroundImage: controller.user?.imageUrl != null
                          ? CachedNetworkImageProvider(context.read<SettingsBloc>().state.user?.imageUrl ?? '')
                          : null,
                      // get string from state user name first letters
                      child: Text(
                        context
                                .watch<SettingsBloc>()
                                .state
                                .user
                                ?.name
                                ?.split(' ')
                                .map((e) => e.substring(0, 1))
                                .join(" ") ??
                            "B",
                        style: context.titleLarge!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Text(
                      context.watch<SettingsBloc>().state.user?.name ?? 'Abullajon',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Text(
                      context.watch<SettingsBloc>().state.user?.email ?? 'adbullajon@gmail.com',
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
                        click: () {
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
                                    initialItem: LanguageRepository.languages
                                        .indexOf(context.read<SettingsBloc>().state.languageModel),
                                  ),
                                  onSelectedItemChanged: (int selectedItem) => context.read<SettingsBloc>().add(
                                      ChangeLanguageEvent(languageModel: LanguageRepository.languages[selectedItem])),
                                  children: List<Widget>.generate(LanguageRepository.languages.length,
                                      (int index) => Center(child: Text(LanguageRepository.languages[index].name))),
                                ),
                              ),
                            ),
                          );
                        },
                        title: LocaleKeys.language.tr(),
                        // action: ValueListenableBuilder(
                        //     valueListenable: appLanguage,
                        //     builder: (p1, p2, p3) {
                        //       return Text(
                        //         p2,
                        //         style: const TextStyle(fontWeight: FontWeight.bold),
                        //       );
                        //     }),
                      ),
                      SettingsItem(
                          title: LocaleKeys.nightMode.tr(),
                          action: Switch(
                              value: context.watch<AppThemeBloc>().state.switchValue,
                              onChanged: (value) {
                                context.read<AppThemeBloc>().add(value ? SwitchOnThemeEven() : SwitchOffThemeEven());
                              })),
                      ValueListenableBuilder(
                          valueListenable: statusNotification,
                          builder: (p1, p2, p3) {
                            return p2 == PermissionStatus.granted
                                ? SettingsItem(
                                    title: LocaleKeys.appSound.tr(),
                                    action: ValueListenableBuilder(
                                      valueListenable: appSound,
                                      builder: (p1, p2, p3) {
                                        return Switch(
                                            value: p2,
                                            onChanged: (value) {
                                              StorageRepository.putBool(key: StoreKeys.appSound, value: value);
                                              appSound.value = value;
                                            });
                                      },
                                    ))
                                : p2 == PermissionStatus.permanentlyDenied || p2 == PermissionStatus.denied
                                    ? SettingsItem(
                                        title: LocaleKeys.permissionIsDenied.tr(),
                                        action: ElevatedButton(
                                          onPressed: () {
                                            openAppSettings();
                                          },
                                          child: Text(LocaleKeys.goSettings.tr()),
                                        ),
                                      )
                                    : SettingsItem(title: LocaleKeys.somethingWentWrong.tr());
                          }),
                      SettingsItem(
                        title: LocaleKeys.savedWords.tr(),
                        screen: const SavedWordsPage(),
                      ),
                      SettingsItem(
                        title: LocaleKeys.help.tr(),
                        screen: const HelpPage(),
                      ),
                      SettingsItem(
                        title: LocaleKeys.about.tr(),
                        screen: const AboutPage(),
                      ),
                      SettingsItem(
                        title: LocaleKeys.logout.tr(),
                        click: () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(LocaleKeys.logout.tr()),
                                content: Text(LocaleKeys.areYouSureYouWantToLogout.tr()),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context), child: Text(LocaleKeys.cancel.tr())),
                                  TextButton(
                                      onPressed: () {
                                        StorageRepository.deleteBool(StoreKeys.isAuth);
                                        StorageRepository.deleteString(StoreKeys.token);
                                        GoogleSignIn().signOut();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => const AuthScreen()),
                                            (route) => false);
                                      },
                                      child: Text(LocaleKeys.logout.tr())),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Rate the app',
                        style: TextStyle(fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Align(
                      child: RatingBar.builder(
                        initialRating: StorageRepository.getDouble(StoreKeys.rating),
                        minRating: 1,
                        allowHalfRating: true,
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
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 20,
                  )),
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
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 65, // Half of width and height of SizedBox
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 30,
              )),
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
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 30,
                ),
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
                child: SizedBox(
                  height: 20,
                ),
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
                child: SizedBox(
                  height: 20,
                ),
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
                child: SizedBox(
                  height: 20,
                ),
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
                child: SizedBox(
                  height: 20,
                ),
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
    );
  }
}
//.then((value) => {
//                                 if (_selectedFruit == 0)
//                                   {
//                                     context.setLocale(const Locale('ru', 'RU')),
//                                   }
//                                 else if (_selectedFruit == 1)
//                                   {
//                                     context.setLocale(const Locale('en', 'US')),
//                                   }
//                                 else
//                                   {
//                                     context.setLocale(const Locale('uz', 'UZ')),
//                                   }
//                               })
