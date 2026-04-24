import '../models/dish_cuisine.dart';

enum CuisineContinent {
  europe,
  asia,
  americas,
  middleEastAfrica,
  oceania;

  String get label => switch (this) {
        CuisineContinent.europe => 'Europe',
        CuisineContinent.asia => 'Asia',
        CuisineContinent.americas => 'Americas',
        CuisineContinent.middleEastAfrica => 'Mid East & Africa',
        CuisineContinent.oceania => 'Oceania',
      };
}

extension DishCuisineContinentX on DishCuisine {
  CuisineContinent get continent => switch (this) {
        DishCuisine.italian ||
        DishCuisine.french ||
        DishCuisine.spanish ||
        DishCuisine.greek ||
        DishCuisine.german ||
        DishCuisine.british ||
        DishCuisine.swiss ||
        DishCuisine.portuguese ||
        DishCuisine.turkish ||
        DishCuisine.russian ||
        DishCuisine.hungarian ||
        DishCuisine.polish ||
        DishCuisine.swedish =>
          CuisineContinent.europe,
        DishCuisine.japanese ||
        DishCuisine.chinese ||
        DishCuisine.korean ||
        DishCuisine.thai ||
        DishCuisine.vietnamese ||
        DishCuisine.indian ||
        DishCuisine.indonesian ||
        DishCuisine.malaysian ||
        DishCuisine.filipino ||
        DishCuisine.singaporean =>
          CuisineContinent.asia,
        DishCuisine.american ||
        DishCuisine.mexican ||
        DishCuisine.brazilian ||
        DishCuisine.argentinian ||
        DishCuisine.peruvian ||
        DishCuisine.cuban ||
        DishCuisine.jamaican ||
        DishCuisine.canadian =>
          CuisineContinent.americas,
        DishCuisine.lebanese ||
        DishCuisine.moroccan ||
        DishCuisine.egyptian ||
        DishCuisine.ethiopian ||
        DishCuisine.southAfrican ||
        DishCuisine.iranian =>
          CuisineContinent.middleEastAfrica,
        DishCuisine.australian => CuisineContinent.oceania,
      };
}
