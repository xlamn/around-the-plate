import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../cubits/dishes_overview_cubit.dart';
import '../cubits/dishes_overview_state.dart';
import '../widgets/dish_card.dart';
import '../widgets/dishes_overview_add_button.dart';

class DishesOverviewPage extends StatelessWidget {
  const DishesOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DishesOverviewCubit(
        dishesRepository: context.read<DishesRepository>(),
      )..loadDishes(),
      child: const DishesOverviewView(),
    );
  }
}

class DishesOverviewView extends StatelessWidget {
  const DishesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            return const Center(child: Text('No dishes available'));
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 100),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: state.dishes.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const FHeader(title: Text('Home'));
              }
              final dish = state.dishes[index - 1];
              return DishCard(dish: dish);
            },
          );
        },
      ),
    );
  }
}
