import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppFunctions{
  AppFunctions._();

  // Admob unitId
  static const String _adUnitId = 'ca-app-pub-3129231972481781/4248828666';

  static Future<void> loadAd(BannerAd? bannerAd) async {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  static Future safeScreen()async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  static Future unSafeScreen()async{
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  static showSettingsDialog(BuildContext context,ValueNotifier switcher,ValueNotifier slider){
    showDialog(context: context, builder: (context) {
      return Dialog(
        child: SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0,top: 10,right: 10,bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Settings',style: TextStyle(fontSize: 20),),
                    ),
                    IconButton(onPressed: (){ Navigator.pop(context); }, icon: const Icon(Icons.close))
                  ],
                ),
                const Expanded(child: SizedBox.shrink()),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0,right: 15,top: 10,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Language'),
                        Text('En'),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AutoSizeText('Hide word’s translate'),
                        ValueListenableBuilder(
                            valueListenable: switcher,
                            builder: (context,p0,p1) {
                              return Switch(value: switcher.value, onChanged: (value){switcher.value=!switcher.value;});
                            }
                        )
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text('change the scale'),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Text('A',),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: slider,
                            builder: (context,p0,p1) {
                              return Slider(value: slider.value.toDouble(),divisions: 8, onChanged: (value){
                                slider.value = value.toInt();
                              },max: 80,min: 0,);
                            }
                        ),
                      ),
                      const Text('A',style: TextStyle(fontSize: 30),),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },);
  }
}