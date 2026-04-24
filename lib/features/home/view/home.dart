import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dishes_overview/view/dishes_overview_page.dart';
import '../../journey_overview/journey_overview.dart';
import '../../settings_overview/view/settings_overview_page.dart';
import '../cubits/home_cubit.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final List<Widget> contents = [
    const DishesOverviewPage(),
    const JourneyOverviewPage(),
    const SettingsOverviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select((HomeCubit cubit) => cubit.state);

    return FScaffold(
      childPad: false,
      footer: FBottomNavigationBar(
        index: selectedIndex,
        onChange: (index) => context.read<HomeCubit>().changeTab(index),
        children: const [
          FBottomNavigationBarItem(
            icon: Icon(FIcons.house),
            label: Text('Home'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.planeTakeoff),
            label: Text('Journey'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.settings),
            label: Text('Settings'),
          ),
        ],
      ),
      child: IndexedStack(
        index: selectedIndex,
        children: contents,
      ),
    );
  }
}
