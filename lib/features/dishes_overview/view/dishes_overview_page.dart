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
      body: BlocBuilder<DishesOverviewCubit, DishesOverviewState>(
        builder: (context, state) {
          if (state.status == DishesOverviewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == DishesOverviewStatus.failure) {
            return const Center(child: Text('Failed to load dishes'));
          }
          if (state.dishes.isEmpty) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  FHeader(
                    title: Text('Home'),
                    suffixes: [
                      DishesOverviewAddButton(),
                    ],
                  ),
                  Expanded(
                    child: const Center(
                      child: Text('You haven\'t added any dishes yet.'),
                    ),
                  ),
                ],
              ),
            );
          }
          return BlocBuilder<DishesSortCubit, DishesSortOption>(
            builder: (_, sortOption) {
              final dishes = state.dishes.sortedBy(sortOption);
              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 100),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: dishes.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: const FHeader(
                        title: Text('Home'),
                        suffixes: [
                          DishesOverviewSortButton(),
                          DishesOverviewAddButton(),
                        ],
                      ),
                    );
                  }
                  final dish = dishes[index - 1];
                  return DishCard(dish: dish);
                },
              );
            },
          );
        },
      ),
    );
  }
}
