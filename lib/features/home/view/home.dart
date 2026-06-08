import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart' hide Tab;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../achievements/achievements.dart';
import '../../home_overview/view/home_overview_page.dart';
import '../../journey_overview/journey_overview.dart';
import '../../settings_overview/view/settings_overview_page.dart';
import '../cubits/home_cubit.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(),
        ),
        BlocProvider(
          create: (_) => AchievementsCubit(
            dishesRepository: context.read<DishesRepository>(),
          ),
        ),
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final List<Widget> contents = [
    const HomeOverviewPage(),
    const JourneyOverviewPage(),
    const SettingsOverviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.select((HomeCubit cubit) => cubit.state);

    return BlocListener<AchievementsCubit, AchievementsState>(
      listenWhen: (prev, curr) => curr.newlyUnlockedAchievements.isNotEmpty,
      listener: (context, state) async {
        final achievements = List.of(state.newlyUnlockedAchievements);
        context.read<AchievementsCubit>().clearNewlyUnlocked();
        await Future.delayed(const Duration(milliseconds: 700));
        for (final achievement in achievements) {
          if (!context.mounted) break;
          await AchievementCelebrationDialog.show(context, achievement);
        }
      },
      child: FScaffold(
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
      ),
    );
  }
}
