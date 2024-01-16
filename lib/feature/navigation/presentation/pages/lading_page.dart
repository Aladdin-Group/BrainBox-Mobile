import 'package:brain_box/feature/education/presentation/education_screen.dart';
import 'package:brain_box/feature/main/presentation/main_screen.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_event.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_state.dart';
import 'package:brain_box/feature/reminder/presentation/reminder_screen.dart';
import 'package:brain_box/feature/settings/presentation/settings_screen.dart';
import 'package:brain_box/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<NavigationDestination> bottomNavigationBars = <NavigationDestination>[
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
];

List<Widget> pages = [
  const MainScreen(),
  const EducationScreen(),
  const ReminderScreen(),
  const SettingsScreen(),
];

class LadingPage extends StatelessWidget {
  const LadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          // body: pages[state.navigationIndex],
          body: IndexedStack(index: state.navigationIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.navigationIndex,
            onDestinationSelected: (index) {
              BlocProvider.of<NavigationBloc>(context).add(NavigationRouteEvent(index: index));
            },
            destinations: bottomNavigationBars,
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
