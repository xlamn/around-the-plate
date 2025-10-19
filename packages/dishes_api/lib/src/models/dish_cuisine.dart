enum DishCuisine {
  // 🇪🇺 Europe
  italian,
  french,
  spanish,
  greek,
  german,
  british,
  swiss,
  portuguese,
  turkish,
  russian,
  hungarian,
  polish,
  swedish,

  // 🇨🇳 Asia
  japanese,
  chinese,
  korean,
  thai,
  vietnamese,
  indian,
  indonesian,
  malaysian,
  filipino,
  singaporean,

  // 🇺🇸 Americas
  american,
  mexican,
  brazilian,
  argentinian,
  peruvian,
  cuban,
  jamaican,
  canadian,

  // 🌍 Middle East & Africa
  lebanese,
  moroccan,
  egyptian,
  ethiopian,
  southAfrican,
  iranian,

  // 🌏 Oceania
  australian,
}

class CountryMapping {
  final String countryName;
  const CountryMapping(this.countryName);
}

const Map<DishCuisine, CountryMapping> cuisineCountryMap = {
  // 🇪🇺 Europe
  DishCuisine.italian: CountryMapping("Italy"),
  DishCuisine.french: CountryMapping("France"),
  DishCuisine.spanish: CountryMapping("Spain"),
  DishCuisine.greek: CountryMapping("Greece"),
  DishCuisine.german: CountryMapping("Germany"),
  DishCuisine.british: CountryMapping("United Kingdom"),
  DishCuisine.swiss: CountryMapping("Switzerland"),
  DishCuisine.portuguese: CountryMapping("Portugal"),
  DishCuisine.turkish: CountryMapping("Turkey"),
  DishCuisine.russian: CountryMapping("Russia"),
  DishCuisine.hungarian: CountryMapping("Hungary"),
  DishCuisine.polish: CountryMapping("Poland"),
  DishCuisine.swedish: CountryMapping("Sweden"),

  // 🇨🇳 Asia
  DishCuisine.japanese: CountryMapping("Japan"),
  DishCuisine.chinese: CountryMapping("China"),
  DishCuisine.korean: CountryMapping("South Korea"),
  DishCuisine.thai: CountryMapping("Thailand"),
  DishCuisine.vietnamese: CountryMapping("Vietnam"),
  DishCuisine.indian: CountryMapping("India"),
  DishCuisine.indonesian: CountryMapping("Indonesia"),
  DishCuisine.malaysian: CountryMapping("Malaysia"),
  DishCuisine.filipino: CountryMapping("Philippines"),
  DishCuisine.singaporean: CountryMapping("Singapore"),

  // 🇺🇸 Americas
  DishCuisine.american: CountryMapping("United States of America"),
  DishCuisine.mexican: CountryMapping("Mexico"),
  DishCuisine.brazilian: CountryMapping("Brazil"),
  DishCuisine.argentinian: CountryMapping("Argentina"),
  DishCuisine.peruvian: CountryMapping("Peru"),
  DishCuisine.cuban: CountryMapping("Cuba"),
  DishCuisine.jamaican: CountryMapping("Jamaica"),
  DishCuisine.canadian: CountryMapping("Canada"),

  // 🌍 Middle East & Africa
  DishCuisine.lebanese: CountryMapping("Lebanon"),
  DishCuisine.moroccan: CountryMapping("Morocco"),
  DishCuisine.egyptian: CountryMapping("Egypt"),
  DishCuisine.ethiopian: CountryMapping("Ethiopia"),
  DishCuisine.southAfrican: CountryMapping("South Africa"),
  DishCuisine.iranian: CountryMapping("Iran"),

  // 🌏 Oceania
  DishCuisine.australian: CountryMapping("Australia"),
};

final Map<String, DishCuisine> _countryToCuisineMap = {
  for (final entry in cuisineCountryMap.entries)
    entry.value.countryName.toLowerCase(): entry.key,
};

DishCuisine? getCuisineFromCountry(String countryName) =>
    _countryToCuisineMap[countryName.toLowerCase()];
