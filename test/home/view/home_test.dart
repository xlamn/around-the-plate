import 'package:around_the_plate/features/dishes_overview/view/dishes_overview_page.dart';
import 'package:around_the_plate/features/map_overview/view/map_overview_page.dart';
import 'package:around_the_plate/features/settings_overview/view/settings_overview_page.dart';
import 'package:around_the_plate/home/view/home.dart';
import 'package:dishes_repository/dishes_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  late DishesRepository dishesRepository;

  setUp(() {
    dishesRepository = MockDishesRepository();
    when(dishesRepository.getDishes).thenAnswer((_) => const Stream.empty());
  });

  group('`Home`', () {
    testWidgets('renders `$DishesOverviewPage` initially', (tester) async {
      await tester.pumpApp(
        const Home(),
        dishesRepository: dishesRepository,
      );

      expect(find.byType(DishesOverviewPage), findsOneWidget);
      expect(find.byType(MapOverviewPage), findsNothing);
      expect(find.byType(SettingsOverviewPage), findsNothing);
    });

    testWidgets('renders `$MapOverviewPage`', (tester) async {
      await tester.pumpApp(
        const Home(),
        dishesRepository: dishesRepository,
      );

      await tester.tap(find.byIcon(FIcons.map));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(DishesOverviewPage), findsNothing);
      expect(find.byType(MapOverviewPage), findsOneWidget);
      expect(find.byType(SettingsOverviewPage), findsNothing);
    });

    testWidgets('renders `$SettingsOverviewPage`', (tester) async {
      await tester.pumpApp(
        const Home(),
        dishesRepository: dishesRepository,
      );

      await tester.tap(find.byIcon(FIcons.settings));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(DishesOverviewPage), findsNothing);
      expect(find.byType(MapOverviewPage), findsNothing);
      expect(find.byType(SettingsOverviewPage), findsOneWidget);
    });
  });
}
