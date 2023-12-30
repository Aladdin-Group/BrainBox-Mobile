import 'package:brain_box/core/exceptions/failure.dart';
import 'package:brain_box/core/utils/app_functions.dart';
import 'package:brain_box/feature/test/presentation/test_screen.dart';
import 'package:brain_box/feature/words/data/models/words_response.dart';
import 'package:brain_box/feature/words/presentation/manager/words_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class WordsScreen extends StatefulWidget {
  int? movieId;
  WordsScreen({super.key,this.movieId});

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
  ValueNotifier<bool> isSuccess = ValueNotifier(false);
  ValueNotifier<String> nameOfMovie = ValueNotifier('NON');
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

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
    return BlocProvider<WordsBloc>(
    create: (context) => WordsBloc()..add(GetMovieInfoEvent(id: widget.movieId??-1)),
    child: Scaffold(
      body: BlocConsumer<WordsBloc, WordsState>(
        builder: (context, state) {
          if(state.status.isInProgress || state.status.isInitial) {
            return ListView.builder(
              itemCount: 10, // arbitrary number for placeholder items
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListTile(
                    title: Container(
                      height: 20,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          }
          if(state.status.isFailure){
            if(state.fail is ServerFailure){
              return const Center(
                child: Text('Some problem, please reload!'),
              );
            }else if(state.fail is DioFailure){
              return const Center(
                child: Center(
                  child: Text('Some problem, please check your internet!'),
                ),
              );
            }else if(state.fail is ParsingFailure){
              return const Center(
                child: Center(
                  child: Text('Please update app to latest version!'),
                ),
              );
            }
          }
          if(state.status.isSuccess){
            List<Content> wordsList = state.listWords;
            return NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: ValueListenableBuilder(
                    valueListenable: nameOfMovie,
                    builder: (context,value,param) {
                      return Text(value);
                    }
                  ),
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
                )
              ],
              body: AnimatedList(
                key: listKey,
                initialItemCount: wordsList.length,
                itemBuilder: (context, index, animation){
                  if (index == wordsList.length - 3) {
                    if (state.wordsCount > wordsList.length) {
                      context.read<WordsBloc>().add(GetMoreWordsEvent(
                        success: (p0) {
                          listKey.currentState?.insertAllItems(index, p0);
                        },
                      ));
                    }
                  }
                  if(index == wordsList.length -1 ){
                    if(state.wordsCount > wordsList.length){
                      return const ListTile(title: CupertinoActivityIndicator());
                    }
                  }
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          '${wordsList[index].value.toString().toUpperCase()} - ${wordsList[index].secondLanguageValue}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        // Container(width: wordsList[index].secondLanguageValue!.length.toDouble()+30, height: 20,color: Colors.black,)
                      ],
                    ),
                    trailing: Text(
                      wordsList[index].count.toString(),
                    ),
                    subtitle: Text(wordsList[index].definition.toString()),
                    leading: Text('${index+1}.',style: const TextStyle(fontSize: 20),),
                  );
                },
              ),
            );
          }
          return const Center(
            child: Text('System error!'),
          );
        }, listener: (BuildContext context, WordsState state) {
          if(state.status.isSuccess){
            isSuccess.value = true;
            if(state.result!=null){
              if(state.result!.name!=null){
                nameOfMovie.value = state.result!.name!;
              }
            }
          }
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: isSuccess,
        builder: (context,value,param) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: value ? 125 : 0,
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
          );
        }
      ),
    ),
);
  }
}
