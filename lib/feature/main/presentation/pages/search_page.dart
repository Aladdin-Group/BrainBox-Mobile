import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/core/route/ruotes.dart';
import 'package:brain_box/feature/main/data/models/Movie.dart';
import 'package:brain_box/feature/main/data/models/movie_availbility.dart';
import 'package:brain_box/feature/main/presentation/manager/main/main_bloc.dart';
import 'package:brain_box/feature/main/presentation/pages/movie_info_page.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';

import '../../../words/presentation/words_screen.dart';

class SearchPage extends StatefulWidget {
  // final MainBloc bloc;
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController movieNameController = TextEditingController();
  bool isOpenDialog = false;
  ValueNotifier<MovieAvailability> isAvailableMovie = ValueNotifier(MovieAvailability.initial);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,

                controller: searchController,
                onChanged: (value) {
                  context.read<MainBloc>().add(SearchMovieEvent(
                      success: (success) {
                        isAvailableMovie.value = MovieAvailability.have;
                        // setState(() {
                        //   listSearch.clear();
                        //   listSearch.addAll(success);
                        // });
                      },
                      failure: () {
                        isAvailableMovie.value = MovieAvailability.not;
                      },
                      keyWord: value));
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: LocaleKeys.search.tr(),
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                return Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: isAvailableMovie,
                      builder: (context, value, p1) {
                        return value == MovieAvailability.initial
                            ? Center(child: Text(LocaleKeys.searchAnyMovie.tr()))
                            : value == MovieAvailability.have
                                ? ListView.builder(
                                    itemCount: state.listSearch.length, // Replace with your data length
                                    itemBuilder: (context, index) {
                                      // if (state.listSearch.length == index) {
                                      //   return SizedBox(
                                      //     height: 90,
                                      //     child: CupertinoButton(
                                      //         onPressed: () {
                                      //           context
                                      //               .read<MainBloc>()
                                      //               .add(SubmitMovieEvent(movieName: searchController.text));
                                      //         },
                                      //         child: Text('Request movie'.tr())),
                                      //   );
                                      // }
                                      return BlocListener<MainBloc, MainState>(
                                        listener: (context, state) {
                                          if (state.getUserInfoStatus.isFailure) {
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (builder) =>
                                                    AlertDialog(title: Text('Something went wrong'.tr())));
                                          }
                                          if (state.getUserInfoStatus.isInProgress) {
                                            showDialog(
                                                context: context,
                                                builder: (builder) => const AlertDialog(
                                                      title: CupertinoActivityIndicator(),
                                                    ));
                                          }
                                          if (state.getUserInfoStatus.isSuccess) {
                                            if (state.user?.isPremium ?? false) {
                                              context.pop();
                                              context.pushNamed(RouteNames.words,
                                                  arguments: state.listSearch[index].id!.toInt());
                                            } else {
                                              if ((state.user?.coins ?? 0) > (state.listSearch[index].price ?? 0)) {
                                              } else {
                                                context.pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                          title: Text('Wrong'.tr()),
                                                          content:
                                                              Text('You dont have enough coins for this movie!'.tr()),
                                                        ));
                                              }
                                            }
                                          }
                                        },
                                        child: ListTile(
                                          onTap: () {
                                            if (state.listSearch[index].isBought ?? false) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => WordsScreen(
                                                      movieId: state.listSearch[index].id!.toInt(),
                                                      title: state.listSearch[index].name,
                                                    ),
                                                  ));
                                            } else {
                                              final movie = state.listSearch[index];
                                              context.push(MovieInfoPage(movie: Content(id:state.listSearch[index].id?.toInt(), name: movie.name, description: movie.description, price: movie.price?.toInt(), isBought: movie.isBought, avatarUrl: movie.avatarUrl,belongAge: movie.belongAge?.toInt(),genre: movie.genre,level: movie.level,serial: movie.serial)));
                                              // context.read<MainBloc>().add(GetUserInfoEvent(
                                                  // Navigator.pop(context);
                                                  // showModalBottomSheet(
                                                  // context: context,
                                                  // builder: (builder) => Container(
                                                  //   width: double.maxFinite,
                                                  //   decoration: const BoxDecoration(
                                                  //       color: Colors.white,
                                                  //       borderRadius: BorderRadius.only(
                                                  //           topLeft: Radius.circular(10),
                                                  //           topRight: Radius.circular(10))),
                                                  //   child: Column(
                                                  //     crossAxisAlignment:
                                                  //     CrossAxisAlignment.start,
                                                  //     children: [
                                                  //       Row(
                                                  //         children: [
                                                  //           Padding(
                                                  //             padding:
                                                  //             const EdgeInsets.all(8.0),
                                                  //             child: SizedBox(
                                                  //               height: 200,
                                                  //               width: 170,
                                                  //               child: Container(
                                                  //                 decoration: BoxDecoration(
                                                  //                     borderRadius:
                                                  //                     BorderRadius
                                                  //                         .circular(15),
                                                  //                     image:
                                                  //                     DecorationImage(
                                                  //                       fit: BoxFit.cover,
                                                  //                       image:
                                                  //                       CachedNetworkImageProvider(
                                                  //                         listSearch[index]
                                                  //                             .avatarUrl ??
                                                  //                             '',
                                                  //                       ),
                                                  //                     )),
                                                  //               ),
                                                  //             ),
                                                  //           ),
                                                  //           Column(
                                                  //             mainAxisAlignment:
                                                  //             MainAxisAlignment
                                                  //                 .spaceAround,
                                                  //             children: [
                                                  //               Padding(
                                                  //                 padding:
                                                  //                 const EdgeInsets.only(
                                                  //                     top: 10.0),
                                                  //                 child: Text(
                                                  //                     'Forcoins'.tr(args: [
                                                  //                       '${listSearch[index].price}',
                                                  //                     ])),
                                                  //               ),
                                                  //               Padding(
                                                  //                 padding:
                                                  //                 const EdgeInsets.all(
                                                  //                     8.0),
                                                  //                 child: SizedBox(
                                                  //                   width: 200,
                                                  //                   child: FittedBox(
                                                  //                     child: AutoSizeText(
                                                  //                       listSearch[index]
                                                  //                           .name ??
                                                  //                           'NULL',
                                                  //                       style: const TextStyle(
                                                  //                           fontWeight:
                                                  //                           FontWeight
                                                  //                               .bold,
                                                  //                           fontSize: 20),
                                                  //                       maxLines: 2,
                                                  //                     ),
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //               SizedBox(
                                                  //                 width: 210,
                                                  //                 height: 170,
                                                  //                 child: Padding(
                                                  //                   padding:
                                                  //                   const EdgeInsets
                                                  //                       .only(
                                                  //                       left: 10.0),
                                                  //                   child: AutoSizeText(
                                                  //                     listSearch[index]
                                                  //                         .description ??
                                                  //                         'NULL',
                                                  //                     maxLines: 10,
                                                  //                     overflow: TextOverflow
                                                  //                         .ellipsis,
                                                  //                   ),
                                                  //                 ),
                                                  //               )
                                                  //             ],
                                                  //           ),
                                                  //         ],
                                                  //       ),
                                                  //       Row(
                                                  //         children: [
                                                  //           Expanded(
                                                  //               child: Padding(
                                                  //                 padding:
                                                  //                 const EdgeInsets.all(8.0),
                                                  //                 child: ElevatedButton(
                                                  //                     onPressed: () {
                                                  //                       Navigator.pop(context);
                                                  //                     },
                                                  //                     child:
                                                  //                     const Text('Cancel')),
                                                  //               )),
                                                  //           Expanded(
                                                  //               child: Padding(
                                                  //                 padding:
                                                  //                 const EdgeInsets.all(8.0),
                                                  //                 child: ElevatedButton(
                                                  //                     onPressed: () {
                                                  //                       context
                                                  //                           .read<MainBloc>()
                                                  //                           .add(BuyMovieEvent(
                                                  //                           success:
                                                  //                               (success) {
                                                  //                             Navigator.pop(
                                                  //                                 context);
                                                  //                             // listSearch[index].isBought = true;
                                                  //                             Navigator.push(
                                                  //                                 context,
                                                  //                                 MaterialPageRoute(
                                                  //                                   builder:
                                                  //                                       (context) =>
                                                  //                                       WordsScreen(
                                                  //                                         movieId: listSearch[index]
                                                  //                                             .id!
                                                  //                                             .toInt(),
                                                  //                                       ),
                                                  //                                 ));
                                                  //                           },
                                                  //                           failure: () {
                                                  //                             Navigator.pop(
                                                  //                                 context);
                                                  //                             showDialog(
                                                  //                                 context:
                                                  //                                 context,
                                                  //                                 builder:
                                                  //                                     (builder) =>
                                                  //                                     AlertDialog(
                                                  //                                       title: Text('Something went wrong'.tr()),
                                                  //                                     ));
                                                  //                           },
                                                  //                           progress: () {
                                                  //                             Navigator.pop(
                                                  //                                 context);
                                                  //                             showDialog(
                                                  //                                 context:
                                                  //                                 context,
                                                  //                                 builder:
                                                  //                                     (builder) =>
                                                  //                                 const AlertDialog(
                                                  //                                   title: CupertinoActivityIndicator(),
                                                  //                                 ));
                                                  //                           },
                                                  //                           movieId: listSearch[
                                                  //                           index]
                                                  //                               .id!
                                                  //                               .toInt() ??
                                                  //                               -1));
                                                  //                     },
                                                  //                     child: Text(
                                                  //                         'Purchase'.tr())),
                                                  //               )),
                                                  //         ],
                                                  //       )
                                                  //     ],
                                                  //   ),
                                                  // ));

                                                  // ));
                                            }
                                          },
                                          title: Text(state.listSearch[index].name ?? 'NULL'), // Replace with your data
                                          subtitle: Text(state.listSearch[index].level ?? ''), // Replace with your data
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        state.listSearch[index].avatarUrl ?? ''))),
                                          ), // Replace with your item icon
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AppImages.noFound, width: 160),
                                        const Gap(20),
                                        Text(
                                          LocaleKeys.weCouldnTFind.tr(),
                                          textAlign: TextAlign.center,
                                          style: context.titleMedium?.copyWith(color: Colors.grey),
                                        ),
                                        const Gap(20),
                                        FilledButton(
                                            onPressed: () {
                                              showAdaptiveDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(LocaleKeys.submit.tr()),
                                                    content: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          controller: movieNameController,
                                                          decoration: InputDecoration(
                                                            border: const OutlineInputBorder(),
                                                            hintText: LocaleKeys.movieName.tr(),
                                                          ),
                                                        ),
                                                        const Gap(16),
                                                        FilledButton(
                                                            onPressed: () {
                                                              context.read<MainBloc>().add(SubmitMovieEvent(
                                                                  movieName: movieNameController.text));
                                                              context.pop();
                                                              movieNameController.clear();
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                 SnackBar(
                                                                  content: Text(LocaleKeys.sentYourOrder.tr()),
                                                                  backgroundColor: Colors.green,
                                                                  behavior: SnackBarBehavior.floating,
                                                                )
                                                              );
                                                            },
                                                            child: Text(LocaleKeys.submit.tr()))
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(LocaleKeys.submit.tr()))
                                        // Text('Not find,but you can order the movie'.tr()),
                                        // CupertinoButton(
                                        //     child: const Text('Request'),
                                        //     onPressed: () {
                                        //       ScaffoldMessenger.of(context)
                                        //           .showSnackBar(const SnackBar(content: Text('Sent your order')));

                                        //     }),
                                      ],
                                    ),
                                  );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
