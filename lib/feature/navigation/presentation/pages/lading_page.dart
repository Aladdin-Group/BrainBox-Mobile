import 'package:brain_box/feature/education/presentation/education_screen.dart';
import 'package:brain_box/feature/main/presentation/main_screen.dart';
import 'package:brain_box/feature/navigation/presentation/cubit/navigation_cubit.dart';
import 'package:brain_box/feature/reminder/presentation/reminder_screen.dart';
import 'package:brain_box/feature/settings/presentation/settings_screen.dart';
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: navigationCubit.changeIndex,
        destinations: navigationCubit.bottomNavigationBars,
      ),
    );
  }
}
