import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/route/ruotes.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/settings/presentation/manager/settings/settings_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../words/presentation/words_screen.dart';
import '../manager/main/main_bloc.dart';

class MovieInfoPage extends StatefulWidget {
  final Content movie;
  const MovieInfoPage({super.key,required this.movie});

  @override
  State<MovieInfoPage> createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.name??'NAME_OF_MOVIE',style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),),
        actions: [
          Text(
            context.read<SettingsBloc>().state.user?.coins.toString() ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
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

        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(LocaleKeys.forcoins.tr(args: ['${widget.movie.price}',]),textAlign: TextAlign.center,style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: AutoSizeText(
                widget.movie.description??'NULL',
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(onPressed: ()=> Navigator.pop(context), child:  Text(LocaleKeys.cancel.tr())),
                )),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(onPressed: (){
context.read<MainBloc>().add(BuyMovieEvent(success: (success){
                      widget.movie.isBought = true;

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WordsScreen(movieId: widget.movie.id,title: widget.movie.name,),));
                    }, failure: (){
                      showDialog(context: context, builder: (builder)=>AlertDialog(title: Text(LocaleKeys.somethingWentWrong.tr()),));
                    }, progress: (){
                      showDialog(context: context, builder: (builder)=>const AlertDialog(title: CupertinoActivityIndicator(),));
                    }, movieId: widget.movie.id??-1));

                  }, child: Text(LocaleKeys.purchase.tr())),
                )),
              ],
            ),
          ),
          SliverFillRemaining(
            fillOverscroll: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: widget.movie.id??-1,
                transitionOnUserGestures: true,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: CachedNetworkImageProvider(widget.movie.avatarUrl??'',),fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
