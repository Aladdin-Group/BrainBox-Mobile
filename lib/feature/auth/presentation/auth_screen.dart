import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/feature/auth/presentation/manager/auth_bloc.dart';
import 'package:brain_box/feature/main/presentation/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/singletons/storage/storage_repository.dart';
import '../../../core/singletons/storage/store_keys.dart';
import '../../navigation/presentation/bloc/navigation_bloc.dart';
import '../../navigation/presentation/pages/lading_page.dart';
import 'manager/auth_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  late NavigationBloc navigationBloc;

  @override
  void initState() {
    super.initState();
    navigationBloc = NavigationBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/auth_background.jpg'),
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent
                        ]
                    )
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: (){
                            StorageRepository.putBool(key: StoreKeys.isSkip, value: true);
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BlocProvider<NavigationBloc>.value(value: navigationBloc,child: const LadingPage(),),), (route) => false);
                          }, icon: const Icon(Icons.close,color: Colors.white,)),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 100,),
                      AutoSizeText(
                        'welcome_back'.tr(),
                        style: GoogleFonts.kronaOne(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 40,
                            left: 20,
                            right: 20
                        ),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: ()async{
                              context.read<AuthBloc>().add(GoogleAuthEvent());
                              // await GoogleSignIn().signIn().then((value) => {
                              //   if(value!=null){
                              //     showDialog(context: context, builder: (BuildContext context){ return AlertDialog(title: Text(value.displayName??'no'),);}),
                              //     StorageRepository.putBool(key: StoreKeys.isAuth, value: true),
                              //     context.read<AuthBloc>().add(GoogleAuthEvent(googleSignInAccount: value))
                              //   }else{
                              //   },
                              //
                              // });

                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    )
                                )
                            ),
                            child: const Text(
                              'Google',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }, listener: (BuildContext context, AuthState state) {
          if(state.status.isInProgress){
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context){
                return const AlertDialog(
                  content: CupertinoActivityIndicator(),
                );
              },
            );
          }else if(state.status.isSuccess){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BlocProvider<NavigationBloc>.value(value: navigationBloc,child: const LadingPage(),),), (route) => false);
          }
        },
        ),
      ),
    );
  }
}
