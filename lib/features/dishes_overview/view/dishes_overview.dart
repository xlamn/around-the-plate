import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/dishes_overview/dishes_overview_cubit.dart';
import '../cubits/dishes_overview/dishes_overview_state.dart';
import '../widgets/dish_card.dart';

class DishesOverview extends StatelessWidget {
  const DishesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DishesOverviewCubit()..loadDishes(),
      child: DishesOverviewView(),
    );
  }
}

class DishesOverviewView extends StatelessWidget {
  const DishesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DishesOverviewCubit, DishesOverviewState>(
      builder: (context, state) {
        if (state.status == DishesOverviewStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == DishesOverviewStatus.failure) {
          return const Center(child: Text('Failed to load dishes'));
        } else if (state.dishes.isEmpty) {
          return const Center(child: Text('No dishes available'));
        } else {
          return ListView.builder(
            itemCount: state.dishes.length,
            itemBuilder: (context, index) {
              final dish = state.dishes[index];
              return DishCard(dish: dish);
            },
          );
        }
      },
    );
  }
}
