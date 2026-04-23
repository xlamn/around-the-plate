import 'dart:ui';

import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/dishes_search/dishes_search_cubit.dart';
import 'dish_card.dart';

class DishesSearchOverlay extends StatelessWidget {
  final List<Dish> dishes;

  const DishesSearchOverlay({super.key, required this.dishes});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DishesSearchCubit(dishes),
      child: const _DishesSearchOverlayView(),
    );
  }
}

class _DishesSearchOverlayView extends StatefulWidget {
  const _DishesSearchOverlayView();

  @override
  State<_DishesSearchOverlayView> createState() => _DishesSearchOverlayViewState();
}

class _DishesSearchOverlayViewState extends State<_DishesSearchOverlayView> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          color: context.theme.colors.background.withValues(alpha: 0.8),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const .symmetric(vertical: AppSizes.spacing16),
                  child: Hero(
                    tag: 'dishes_search_bar',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        margin: const .symmetric(horizontal: AppSizes.spacing16),
                        padding: const .all(AppSizes.spacing12),
                        decoration: BoxDecoration(
                          color: context.theme.colors.muted,
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          border: Border.all(
                            color: context.theme.colors.border,
                            width: 0.2,
                          ),
                        ),
                        child: Row(
                          spacing: AppSizes.spacing12,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.arrow_back,
                                size: AppSizes.iconM,
                                color: context.theme.colors.mutedForeground,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                controller: _controller,
                                onChanged: (query) =>
                                    context.read<DishesSearchCubit>().search(query),
                                decoration: InputDecoration(
                                  hintText: 'Search dishes...',
                                  hintStyle: context.theme.typography.sm.copyWith(
                                    color: context.theme.colors.mutedForeground,
                                  ),
                                  border: .none,
                                  contentPadding: .zero,
                                  isDense: true,
                                ),
                                style: context.theme.typography.sm,
                              ),
                            ),
                            if (_hasText)
                              GestureDetector(
                                onTap: () {
                                  _controller.clear();
                                  context.read<DishesSearchCubit>().search('');
                                },
                                child: Icon(
                                  Icons.close,
                                  size: AppSizes.iconM,
                                  color: context.theme.colors.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<DishesSearchCubit, DishesSearchState>(
                    builder: (context, state) {
                      if (state.query.trim().isEmpty) {
                        return const SizedBox.shrink();
                      }
                      if (state.filteredDishes.isEmpty) {
                        return Center(
                          child: Text(
                            'No dishes found',
                            style: context.theme.typography.sm.copyWith(
                              color: context.theme.colors.mutedForeground,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const .symmetric(
                          vertical: AppSizes.spacing16,
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spacing16),
                        itemCount: state.filteredDishes.length,
                        itemBuilder: (_, i) => DishCard(dish: state.filteredDishes.elementAt(i)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }
}
