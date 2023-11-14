import 'package:brain_box/assets/theme/color_schemes.g.dart';
import 'package:brain_box/core/constants/icons.dart';
import 'package:brain_box/feature/education/presentation/education_screen.dart';
import 'package:brain_box/feature/main/presentation/main_screen.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_event.dart';
import 'package:brain_box/feature/navigation/presentation/bloc/navigation_state.dart';
import 'package:brain_box/feature/reminder/presentation/reminder_screen.dart';
import 'package:brain_box/feature/settings/presentation/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

List<NavigationDestination> bottomNavigationBars = <NavigationDestination>[
  const NavigationDestination(
      tooltip: 'Home',
      icon: Icon(Icons.home_filled),
      label: 'Home',
  ),
  const NavigationDestination(
      tooltip: 'Education',
      icon: Icon(Icons.school),
      label: 'Education',
  ),
  const NavigationDestination(
      tooltip: 'Reminder',
      icon: Icon(Icons.notifications),
      label: 'Reminder',
  ),
  const NavigationDestination(
      tooltip: 'Settings',
      icon: Icon(Icons.settings),
      label: 'Settings',
  ),
];

List<Widget> pages = [
  MainScreen(),
  EducationScreen(),
  ReminderScreen(),
  SettingsScreen(),
];

class LadingPage extends StatelessWidget {
  const LadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationBloc,NavigationState>(
        builder: (context, state) {
          return Scaffold(
              body: pages[state.navigationIndex],
              bottomNavigationBar: NavigationBar(
                selectedIndex: state.navigationIndex,
                onDestinationSelected: (index){
                  BlocProvider.of<NavigationBloc>(context).add(NavigationRouteEvent(index: index));
                }, destinations: bottomNavigationBars,
              ),
          );
        },
        listener: (context, state) {

        },
    );
  }
}
