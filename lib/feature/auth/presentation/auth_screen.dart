import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/core/assets/constants/colors.dart';
import 'package:brain_box/core/assets/constants/text_styles.dart';
import 'package:brain_box/core/assets/logo/google_logo_painter.dart';
import 'package:brain_box/core/materials/custom_button.dart';
import 'package:brain_box/feature/auth/presentation/manager/auth_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:brain_box/feature/navigation/presentation/pages/lading_page.dart';

import 'package:brain_box/core/custom_lib/apple_sign_in/lib/sign_in_with_apple.dart';


class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  ValueNotifier<bool> progress = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          builder: (blocContext, state) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppImages.authBackground),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(gradient: AppColors.authTopGradient),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     IconButton(onPressed: (){
                    //       StorageRepository.putBool(key: StoreKeys.isSkip, value: true);
                    //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BlocProvider<NavigationBloc>.value(value: navigationBloc,child: const LadingPage(),),), (route) => false);
                    //     }, icon: const Icon(Icons.close,color: Colors.white,)),
                    //     const SizedBox(width: 20),
                    //   ],
                    // ),
                    const Gap(100),
                    AutoSizeText(
                      LocaleKeys.welcomeBack.tr(),
                      style: AppTextStyles.authTitle,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(40),
                    Platform.isAndroid ?
                    SizedBox(
                      height: 50,
                      child: CustomButton(
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          context.read<AuthBloc>().add(IsDevModeEvent());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                            width: 20 * (25 / 31),
                            height: 20,
                            child: CustomPaint(
                              painter: GoogleLogoPainter(),
                            ),),
                            const Gap(15),
                            Flexible(child: Text(LocaleKeys.signWithGoogle.tr(), style: AppTextStyles.titleLarge.copyWith(
                              color: theme.colorScheme.primary
                            )))
                          ],
                        ),
                      ),
                    )
                        : ValueListenableBuilder(valueListenable: progress, builder: (thi,value,widget){
                            return SignInWithAppleButton(
                              text: 'apple_sign_in'.tr(),
                              onPressed: () async {
                                context.read<AuthBloc>().add(IsDevModeEvent());
                                // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                              },
                              progress: progress.value,
                            );
                      }),
                    const Expanded(child: SizedBox.shrink(),),
                    Text(
                        LocaleKeys.eula.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(20)
                  ],
                ),
              ),
            );
          },
          listener: (BuildContext context, AuthState state) async {
            if(state.status.isInProgress){
              progress.value = true;
            }else if (state.status.isSuccess) {
              context.pushAndRemoveUntil( const LadingPage());
            } else if (state.status.isFailure) {
              progress.value = false;
              if (!context.mounted) return;
              Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: theme.primaryColor,
                  textColor: Colors.white,
                  fontSize: 20.0
              );
            }else if(state.status.isCanceled){
              progress.value = false;
            }
          },
        ),
      ),
    );
  }
}
