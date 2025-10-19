enum DishCuisine {
  // 🇪🇺 Europe
  italian("Italy", "IT"),
  french("France", "FR"),
  spanish("Spain", "ES"),
  greek("Greece", "GR"),
  german("Germany", "DE"),
  british("United Kingdom", "GB"),
  swiss("Switzerland", "CH"),
  portuguese("Portugal", "PT"),
  turkish("Turkey", "TR"),
  russian("Russia", "RU"),
  hungarian("Hungary", "HU"),
  polish("Poland", "PL"),
  swedish("Sweden", "SE"),

  // 🇨🇳 Asia
  japanese("Japan", "JP"),
  chinese("China", "CN"),
  korean("South Korea", "KR"),
  thai("Thailand", "TH"),
  vietnamese("Vietnam", "VN"),
  indian("India", "IN"),
  indonesian("Indonesia", "ID"),
  malaysian("Malaysia", "MY"),
  filipino("Philippines", "PH"),
  singaporean("Singapore", "SG"),

  // 🇺🇸 Americas
  american("United States", "US"),
  mexican("Mexico", "MX"),
  brazilian("Brazil", "BR"),
  argentinian("Argentina", "AR"),
  peruvian("Peru", "PE"),
  cuban("Cuba", "CU"),
  jamaican("Jamaica", "JM"),
  canadian("Canada", "CA"),

  // 🌍 Middle East & Africa
  lebanese("Lebanon", "LB"),
  moroccan("Morocco", "MA"),
  egyptian("Egypt", "EG"),
  ethiopian("Ethiopia", "ET"),
  southAfrican("South Africa", "ZA"),
  iranian("Iran", "IR"),

  // 🌏 Oceania
  australian("Australia", "AU");

  final String countryName;
  final String countryCode;
  const DishCuisine(this.countryName, this.countryCode);
}

DishCuisine? getCuisineFromCountry(String countryName) =>
    DishCuisine.values.firstWhere(
      (c) => c.countryName.toLowerCase() == countryName.toLowerCase(),
    );
