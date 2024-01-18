import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:brain_box/core/assets/constants/app_images.dart';
import 'package:brain_box/core/assets/constants/colors.dart';
import 'package:brain_box/core/assets/constants/text_styles.dart';
import 'package:brain_box/core/singletons/storage/storage_repository.dart';
import 'package:brain_box/core/singletons/storage/store_keys.dart';
import 'package:brain_box/core/utils/custom_styles.dart';
import 'package:brain_box/core/utils/dialogs.dart';
import 'package:brain_box/feature/auth/presentation/manager/auth_bloc.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gap/gap.dart';
import 'package:brain_box/feature/navigation/presentation/pages/lading_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
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
                  SizedBox(
                    height: 50,
                    child: FilledButton.tonal(
                      onPressed: () async {
                        context.read<AuthBloc>().add(IsDevModeEvent());
                      },
                      style: CustomStyles.buttonStyle,
                      child: Text(LocaleKeys.signWithGoogle.tr(), style: AppTextStyles.titleLarge),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        listener: (BuildContext context, AuthState state) async {
          if (state.status.isInProgress) {
            CustomDialogs.showLoadingDialog(context);
          } else if (state.status.isSuccess) {
            context.pushAndRemoveUntil(const LadingPage());
          } else if (state.status.isFailure) {
            // if (!context.mounted) return;
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) =>
            //       AlertDialog(title: Text(account.displayName ?? 'no')),
            // );
          }
        },
      ),
    );
  }
}
