import 'package:brain_box/core/utils/app_functions.dart';
import 'package:brain_box/feature/test/presentation/test_screen.dart';
import 'package:brain_box/feature/words/presentation/widgets/word_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> with TickerProviderStateMixin {

  ValueNotifier<bool> switcher = ValueNotifier(false);
  ValueNotifier<int> slider = ValueNotifier(0);
  static const String _adUnitId = 'ca-app-pub-3129231972481781/1815921222';
  late TabController tabController;
  late PageController pageController;
  BannerAd? _bannerAd;

  void loadAd() {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
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

  @override
  void initState() {
    // AppFunctions.safeScreen();
    tabController = TabController(length: 4, vsync: this);
    pageController = PageController();
    loadAd();
    super.initState();
  }



  @override
  void dispose()async{
    super.dispose();
    // AppFunctions.unSafeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('Words'),
            actions: [
              const Text('300',style: TextStyle(fontSize: 17),),
              // Image.asset(AppIcons.coin),
              const Icon(CupertinoIcons.bitcoin_circle_fill),
              IconButton(onPressed: (){
                AppFunctions.showSettingsDialog(context, switcher, slider);
              },icon: const Icon(Icons.settings)),
            ],
            pinned: true,
            floating: true,
            bottom: TabBar(
                controller: tabController,
                isScrollable: true,
                tabs: const [
                  Tab(child: Text('All')),
                  Tab(child: Text('frequently')),
                  Tab(child: Text('standard')),
                  Tab(child: Text('obscure words')),
                ]
            ),
          )
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(left: 8.0,bottom: 10),
                child: WordItemWidget(),
              ),
            ),
            const Center(
              child: Text('data'),
            ),
            const Center(
              child: Text('data'),
            ),
            const Center(
              child: Text('data'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 125,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TestScreen(),));
              }, child: const Text('Start Test')),
              const SizedBox(height: 10,),
              _bannerAd != null ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!,),
              ) : const SizedBox(
                height: 50,
                child: Center(child: Text('Loading Ad...')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
