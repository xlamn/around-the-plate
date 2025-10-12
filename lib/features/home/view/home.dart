import 'package:around_the_plate/features/home/cubits/home_cubit.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../dishes_overview/view/dishes_overview_page.dart';
import '../../map_overview/view/map_overview_page.dart';
import '../../settings_overview/view/settings_overview_page.dart';

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

  final List<FHeader> headers = [
    const FHeader(title: Text('Home')),
    const FHeader(title: Text('Map')),
    FHeader(
      title: const Text('Settings'),
      suffixes: [
        FHeaderAction(
          icon: Icon(FIcons.ellipsis),
          onPress: () {},
        ),
      ],
    ),
  ];
  final List<Widget> contents = [
    DishesOverviewPage(),
    MapOverviewPage(),
    SettingsOverviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select((HomeCubit cubit) => cubit.state);

    return FScaffold(
      childPad: false,
      header: headers[selectedIndex],
      footer: FBottomNavigationBar(
        index: selectedIndex,
        onChange: (index) => context.read<HomeCubit>().changeTab(index),
        children: const [
          FBottomNavigationBarItem(
            icon: Icon(FIcons.house),
            label: Text('Home'),
          ),
          FBottomNavigationBarItem(
            icon: Icon(FIcons.map),
            label: Text('Map'),
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
