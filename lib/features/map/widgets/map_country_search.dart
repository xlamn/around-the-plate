import 'package:app_theme/app_theme.dart';
import 'package:dishes_api/dishes_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/map_controller/map_controller_cubit.dart';
import '../cubits/map_data/map_data_cubit.dart';
import '../cubits/map_interaction/map_interaction_cubit.dart';
import '../models/visited_country.dart';

class MapCountrySearch extends StatefulWidget {
  const MapCountrySearch({super.key});

  @override
  State<MapCountrySearch> createState() => _MapCountrySearchState();
}

class _MapCountrySearchState extends State<MapCountrySearch> {
  static const _duration = Duration(milliseconds: 350);
  static const _collapsedSize = 44.0;

  final _controller = TextEditingController();
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final visitedCountries = context.watch<MapDataCubit>().state.visitedCountries;
    final query = _controller.text.trim().toLowerCase();
    final results = !_expanded || query.isEmpty
        ? const <VisitedCountry>[]
        : visitedCountries
              .where((c) => c.cuisine.countryName.toLowerCase().contains(query))
              .toList();
    return AnimatedContainer(
      duration: _duration,
      curve: Curves.easeInOut,
      width: _expanded ? MediaQuery.of(context).size.width * 0.9 : _collapsedSize,
      padding: .all(_expanded ? AppSizes.spacing8 : 0),
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        color: _expanded ? context.theme.colors.background : context.theme.colors.secondary,
        borderRadius: .circular(AppSizes.radiusM),
        border: _expanded ? .all(color: context.theme.colors.border) : null,
      ),
      child: AnimatedSize(
        duration: _duration,
        curve: Curves.easeInOut,
        alignment: .topRight,
        child: _expanded
            ? _buildExpandedContent(context, results)
            : _buildCollapsedContent(context),
      ),
    );
  }

  Widget _buildCollapsedContent(BuildContext context) {
    return SizedBox(
      width: _collapsedSize,
      height: _collapsedSize,
      child: IconButton(
        onPressed: () => setState(() => _expanded = true),
        icon: Icon(FIcons.search, color: context.theme.colors.secondaryForeground),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, List<VisitedCountry> results) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: AppSizes.spacing8,
      children: [
        FTextField(
          control: FTextFieldControl.managed(controller: _controller),
          hint: 'Search a country...',
          autofocus: true,
          prefixBuilder: (context, style, variants) => FTextField.prefixIconBuilder(
            context,
            style,
            variants,
            const Icon(FIcons.search),
          ),
          suffixBuilder: (context, style, variants) => GestureDetector(
            onTap: _collapse,
            child: Padding(
              padding: const .symmetric(horizontal: 8.0),
              child: Icon(
                FIcons.x,
                size: AppSizes.iconS,
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
        ),
        if (results.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 220),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (_, index) {
                final country = results[index];
                return ListTile(
                  dense: true,
                  contentPadding: .zero,
                  leading: Text(
                    country.cuisine.flagEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(country.cuisine.countryName),
                  trailing: Text('${country.dishCount}'),
                  onTap: () => _selectCountry(country),
                );
              },
            ),
          ),
      ],
    );
  }

  void _selectCountry(VisitedCountry country) {
    context.read<MapControllerCubit>().flyToCountry(country.center);
    final dishes = context.read<MapDataCubit>().state.dishes;
    context.read<MapInteractionCubit>().onCountrySelected(country.cuisine.countryName, dishes);
    _collapse();
  }

  void _collapse() {
    setState(() {
      _expanded = false;
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
