import 'package:brain_box/feature/navigation/presentation/cubit/navigation_cubit.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LadingPage extends StatelessWidget {
  const LadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationCubit = context.read<NavigationCubit>();
    // var for watch
    final index = context.watch<NavigationCubit>().state;
    return Scaffold(
      // body: pages[state.navigationIndex],
      body: IndexedStack(index: index, children: navigationCubit.pages),
      bottomNavigationBar: Localizations.override(
        context: context,
        locale: context.locale,
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: navigationCubit.changeIndex,
          destinations: <NavigationDestination>[
            NavigationDestination(
              tooltip: LocaleKeys.home.tr(),
              icon: const Icon(Icons.home_filled),
              label: LocaleKeys.home.tr(),
            ),
            NavigationDestination(
              tooltip: LocaleKeys.education.tr(),
              icon: const Icon(Icons.school),
              label: LocaleKeys.education.tr(),
            ),
            NavigationDestination(
              tooltip: LocaleKeys.reminder.tr(),
              icon: const Icon(Icons.notifications),
              label: LocaleKeys.reminder.tr(),
            ),
            NavigationDestination(
              tooltip: LocaleKeys.settings.tr(),
              icon: const Icon(Icons.settings),
              label: LocaleKeys.settings.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
