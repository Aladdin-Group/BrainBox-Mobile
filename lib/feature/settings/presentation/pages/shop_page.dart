import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:brain_box/core/utils/background_controller.dart';
import 'package:brain_box/feature/settings/data/models/update_user.dart';
import 'package:brain_box/feature/settings/presentation/manager/settings/settings_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/user.dart';

InAppPurchase _inAppPurchase = InAppPurchase.instance;
late StreamSubscription<dynamic> _streamSubscription;
List<ProductDetails> _products = [];
const _variant = {'5000_coins', '500_coins', 'premuim_for_one_year'};

class ShopPage extends StatefulWidget {
  SettingsBloc bloc;
  User user;
  ShopPage({super.key,required this.bloc,required this.user});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

RewardedAd? _rewardedAd;

void _createRewardedAd() {
  RewardedAd.load(
    adUnitId: 'ca-app-pub-3129231972481781/1874947156', // Use AdMob test ad unit ID for testing
    request: AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (RewardedAd ad) {
        _rewardedAd = ad;
      },
      onAdFailedToLoad: (LoadAdError error) {
        print('RewardedAd failed to load: $error');
      },

    ),
  );
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    _createRewardedAd();
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _streamSubscription = purchaseUpdated.listen((purchaseList) {
      _listenToPurchase(purchaseList, context);
    }, onDone: () {
      _streamSubscription.cancel();
      BackgroundController.startService();
    }, onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('failure'.tr())));
    });
    initStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('appTitle'.tr()),
        ),
        body: ListView(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                      'coins500'.tr(), '0.99\$', 'assets/images/img.png', 70,widget.bloc,widget.user,context,
                      posPay: 1),
                ),
                Expanded(
                  child: _buildOptionCard(
                      'coins5000'.tr(), '4.99\$', 'assets/images/img.png', 70,widget.bloc,widget.user,context,
                      posPay: 0),
                ),
              ],
            ),
            _buildOptionCard('premiumYear'.tr(), '9.99\$',
                'assets/images/img_1.png', 100,widget.bloc,widget.user, context,
                isVertical: false, posPay: 2),
            _buildOptionCard('getCoinsForWatching'.tr(), 'Watch video',
                'assets/images/img_2.png', 100,widget.bloc,widget.user,context,
                isVideoOption: true, isVertical: false, isSub: true),
            _buildOptionCard(''.tr(), 'Pay with telegram bot'.tr(),
                'assets/images/telegram.png', 100,widget.bloc,widget.user,context,
                isVideoOption: false, isVertical: false, isSub: false,isTelegram: true),
          ],
        ),
      ),
    );
  }

  initStore() async {
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_variant);

    if (productDetailsResponse.error == null) {
      setState(() {
        _products = productDetailsResponse.productDetails;
      });
    }
  }

  _listenToPurchase(
      List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showCupertinoDialog(
          context: context,
          builder: (context) =>  CupertinoAlertDialog(
            title: Text('pending'.tr()),
          ),
        );
        BackgroundController.startService();
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('payingError'.tr()),
          ),
        );
        BackgroundController.startService();
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        var json =
            jsonDecode(purchaseDetails.verificationData.localVerificationData);
        if(json['productId']=='500_coins'){
          widget.bloc.add(UpdateUseDataEven(user: UpdateUser(addCoin: 500, userId: widget.user.id??-1), success: () {
            Navigator.pop(context,true);
            Navigator.pop(context,true);
          }, failure: () {
            Navigator.pop(context);
            showDialog(context: context, builder: (builder)=> AlertDialog(title: Text('failure'.tr()),));
          }, progress: () {
            showDialog(context: context, builder: (context)=>const AlertDialog(content: CupertinoActivityIndicator(),),barrierDismissible: false);
          },));
        }else if(json['productId']=='5000_coins'){
          widget.bloc.add(UpdateUseDataEven(user: UpdateUser(addCoin: 5000, userId: widget.user.id??-1), success: () {
            Navigator.pop(context,true);
            Navigator.pop(context,true);
          }, failure: () {
            Navigator.pop(context);
            showDialog(context: context, builder: (builder)=> AlertDialog(title: Text('failure'.tr()),));
          }, progress: () {
            showDialog(context: context, builder: (context)=>const AlertDialog(content: CupertinoActivityIndicator(),),barrierDismissible: false);
          },));
        }else if(json['productId']=='premuim_for_one_year'){
          widget.bloc.add(SubscribePremiumEvent(
              success: () {
                Navigator.pop(context,true);
                Navigator.pop(context,true);
              },
              failure: () {
                Navigator.pop(context);
                showDialog(context: context, builder: (builder)=> AlertDialog(title: Text('failure'.tr()),));
              },
              progress: () {
                showDialog(context: context, builder: (context)=>const AlertDialog(content: CupertinoActivityIndicator(),),barrierDismissible: false);
              }
          ));
        }
        BackgroundController.startService();
      }
    });
  }
}

_buy(int pos, {bool isSub = false}) {
  if (Platform.isAndroid) {
    final PurchaseParam param = PurchaseParam(productDetails: _products[pos]);
    if (isSub) {
      _inAppPurchase.buyNonConsumable(purchaseParam: param);
    } else {
      _inAppPurchase.buyConsumable(purchaseParam: param);
    }
  }
}

Widget _buildOptionCard(
    String title, String buttonText, String imagePath, double size,SettingsBloc bloc,User user,
    BuildContext context,
    {bool isVideoOption = false,
    bool isVertical = true,
      bool isTelegram = false,
    int posPay = 0,
    bool isSub = false}) {
  return Container(
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 2), // changes position of shadow
      ),
    ]),
    child: Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isVertical
            ? Column(
                children: <Widget>[
                  Image.asset(
                    imagePath,
                    width: size,
                    height: 70,
                  ),
                  const SizedBox(height: 8),
                  Text(title),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      BackgroundController.stopService().then((value) => {
                            _inAppPurchase.restorePurchases(),
                            _buy(posPay),
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: Text(buttonText),
                  ),
                  if (isVideoOption) ...[
                    const SizedBox(height: 8),
                    Text('watchVideo'.tr()),
                  ]
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset(
                    imagePath,
                    width: size,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Text(title),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async{
                          var botUrl = 'https://t.me/brainboxxbot';
                          print(_products.length);
                          if(isTelegram){
                            if (await canLaunchUrl(Uri.parse(botUrl))) {
                              await launchUrl(Uri.parse(botUrl));
                            } else {
                              throw 'Could not launch $botUrl';
                            }
                          }else{
                            if (isSub) {
                              if (_rewardedAd != null) {
                                _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
                                  onAdShowedFullScreenContent: (RewardedAd ad) => {},
                                  onAdDismissedFullScreenContent: (RewardedAd ad) {
                                    ad.dispose();
                                    _createRewardedAd(); // Load a new ad for the next button click
                                  },
                                  onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('onAdFailedToShowFullScreenContent: $error')));
                                    ad.dispose();
                                    _createRewardedAd(); // Load a new ad for the next button click
                                  },
                                );

                                _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('youEarned'.tr(args: ['${reward.amount}']))));
                                  bloc.add(UpdateUseDataEven(user: UpdateUser(addCoin: reward.amount.toInt(), userId: user.id??-1), success: () {
                                    Navigator.pop(context,true);
                                    Navigator.pop(context,true);
                                  }, failure: () {
                                    Navigator.pop(context);
                                    showDialog(context: context, builder: (builder)=> const AlertDialog(title: Text('Failure'),));
                                  }, progress: () {
                                    showDialog(context: context, builder: (context)=>const AlertDialog(content: CupertinoActivityIndicator(),),barrierDismissible: false);
                                  },));
                                  // Handle the reward
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('rewardedAdNotLoaded'.tr())));
                              }
                            } else {
                              BackgroundController.stopService()
                                  .then((value) => {
                                _buy(posPay, isSub: true),
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        child: Text(buttonText),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    ),
  );
}
