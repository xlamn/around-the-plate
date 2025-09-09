import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/dishes_overview_cubit.dart';
import '../cubits/dishes_overview_state.dart';
import '../widgets/dishes_overview_add_button.dart';
import '../widgets/dish_card.dart';

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
          } else if (state.status == DishesOverviewStatus.failure) {
            return const Center(child: Text('Failed to load dishes'));
          } else if (state.dishes.isEmpty) {
            return const Center(child: Text('No dishes available'));
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 16.0,
                );
              },
              padding: EdgeInsets.only(bottom: 80),
              shrinkWrap: true,
              itemCount: state.dishes.length,
              itemBuilder: (context, index) {
                final dish = state.dishes[index];
                return DishCard(dish: dish);
              },
            );
          }
        },
      ),
    );
  }
}
