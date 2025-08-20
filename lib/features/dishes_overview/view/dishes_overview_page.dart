import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../add_dish/view/add_dish_bottom_sheet.dart';
import '../../take_picture/view/take_picture_screen.dart';
import '../cubits/dishes_overview/dishes_overview_cubit.dart';
import '../cubits/dishes_overview/dishes_overview_state.dart';
import '../widgets/dish_card.dart';

class DishesOverviewPage extends StatelessWidget {
  const DishesOverviewPage({super.key});

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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FButton(
        onPress: () async {
          final cameras = await availableCameras();
          final firstCamera = cameras.first;
          if (!context.mounted) return;
          final imagePath = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                camera: firstCamera,
              ),
            ),
          );

          if (!context.mounted) return;

          if (imagePath != null) {
            final bool? forceRefresh = await showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              builder: (_) => AddDishBottomSheet(
                imagePath: imagePath,
              ),
            );
            if (forceRefresh != null && forceRefresh) {
              if (!context.mounted) return;
              context.read<DishesOverviewCubit>().loadDishes();
            }
          }
        },
        child: const Text('Add New Dish'),
      ),
      body: Column(
        spacing: 16.0,
        children: [
          BlocBuilder<DishesOverviewCubit, DishesOverviewState>(
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
          ),
        ],
      ),
    );
  }
}
