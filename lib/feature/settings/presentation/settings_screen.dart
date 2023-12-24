import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/feature/settings/presentation/manager/theme/app_theme_bloc.dart';
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
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/constants/icons.dart';
import '../data/models/user.dart';
import 'manager/settings/settings_bloc.dart';


InAppPurchase _inAppPurchase = InAppPurchase.instance;
late StreamSubscription<dynamic> _streamSubscription;
List<ProductDetails> _products = [];
List<ProductDetails> appleProducts = [];
const _variant = {'get_coin_30'};

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late User user;
  ValueNotifier<bool> themeMode = ValueNotifier(false);
  ValueNotifier<bool> appSound = ValueNotifier(false);
  ValueNotifier<bool> isInit = ValueNotifier(false);
  ValueNotifier<String> appLanguage = ValueNotifier('En');
  ValueNotifier<PermissionStatus> statusNotification = ValueNotifier(PermissionStatus.denied);


  @override
  void initState() {
    appLanguage.value = StorageRepository.getString(StoreKeys.appLang);
    themeMode.value = StorageRepository.getBool(StoreKeys.appTheme);
    appSound.value = StorageRepository.getBool(StoreKeys.appSound);
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _streamSubscription = purchaseUpdated.listen((purchaseList) {
      _listenToPurchase(purchaseList, context);
    }, onDone: (){
      _streamSubscription.cancel();
    }, onError: (error){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error')));
    });
    initStore();
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
        isInit.value = true;
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
            ValueListenableBuilder(
              valueListenable: isInit,
              builder: (p1,p2,p3) {
                return p2 ? Text(user.coins.toString(),style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),) : const SizedBox();
              }
            ),
            IconButton(icon: const Icon(Icons.add_circle),onPressed: (){_buy();},),
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
                        GestureDetector(
                          onTap: (){
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: new Icon(Icons.photo),
                                        title: new Text('Photo'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: new Icon(Icons.music_note),
                                        title: new Text('Music'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: new Icon(Icons.videocam),
                                        title: new Text('Video'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: new Icon(Icons.share),
                                        title: new Text('Share'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: SettingsItem(
                            title: 'Language',
                            action: ValueListenableBuilder(
                              valueListenable: appLanguage,
                              builder: (p1,p2,p3) {
                                return Text(p2,style: const TextStyle(fontWeight: FontWeight.bold),);
                              }
                            ),
                          ),
                        ),
                        BlocBuilder<AppThemeBloc, AppThemeState>(
                          builder: (context, state) {
                            return SettingsItem(
                              title: 'Night mode',
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
                    const SliverToBoxAdapter(child: SizedBox(height: 20,)),
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
  initStore() async{
    ProductDetailsResponse productDetailsResponse =
    await _inAppPurchase.queryProductDetails(_variant);

    if(productDetailsResponse.error==null){
      setState(() {
        _products = productDetailsResponse.productDetails;
      });
    }

  }
  _listenToPurchase(List<PurchaseDetails> purchaseDetailsList, BuildContext context) {

    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(title: Text('Pending !'),),);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(title: Text('Paying error'),),);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        var json = jsonDecode(purchaseDetails.verificationData.localVerificationData);
        showDialog(context: context, builder: (context)=> AlertDialog(title: Text(json['quantity']),));

      }
    });

  }
}

_buy(){
  if(Platform.isAndroid){
    final PurchaseParam param = PurchaseParam(productDetails: _products[0]);
    _inAppPurchase.buyConsumable(purchaseParam: param);
  }else{
    final PurchaseParam param = PurchaseParam(productDetails: appleProducts[0]);
    _inAppPurchase.buyConsumable(purchaseParam: param);
  }
}