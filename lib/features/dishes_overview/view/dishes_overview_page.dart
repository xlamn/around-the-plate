import 'package:app_theme/app_theme.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/dishes_data/dishes_overview_cubit.dart';
import '../cubits/dishes_sort/dishes_sort_cubit.dart';
import '../extension/dishes_extension.dart';
import '../models/dishes_sort_option.dart';
import '../widgets/dish_card.dart';
import '../widgets/dishes_overview_add_button.dart';
import '../widgets/dishes_overview_sort_button.dart';
import '../widgets/dishes_search_bar.dart';

class DishesOverviewPage extends StatelessWidget {
  const DishesOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DishesOverviewCubit(
            dishesRepository: context.read<DishesRepository>(),
          )..loadDishes(),
        ),
        BlocProvider(
          create: (_) => DishesSortCubit(),
        ),
      ],
      child: const DishesOverviewView(),
    );
  }
}

class DishesOverviewView extends StatelessWidget {
  const DishesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(FIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: const DishesSearchBar(),
        actions: const [
          DishesOverviewSortButton(),
          SizedBox(width: AppSizes.spacing16),
        ],
      ),
      floatingActionButton: const DishesOverviewAddButton(),
      body: BlocBuilder<DishesOverviewCubit, DishesOverviewState>(
        builder: (context, state) {
          if (state.status == DishesOverviewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == DishesOverviewStatus.failure) {
            return const Center(child: Text('Failed to load dishes'));
          }
          if (state.dishes.isEmpty) {
            return const Center(
              child: Text('You haven\'t added any dishes yet.'),
            );
          }
          return BlocBuilder<DishesSortCubit, DishesSortOption>(
            builder: (_, sortOption) {
              final dishes = state.dishes.sortedBy(sortOption);
              return ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spacing16),
                padding: const .symmetric(
                  vertical: AppSizes.spacing16,
                ),
                itemCount: dishes.length,
                itemBuilder: (_, index) => DishCard(
                  dish: dishes.elementAt(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
