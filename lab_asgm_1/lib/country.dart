class Country {
  final String name;
  final String capital;
  final String currency;
  final String iso2;

  Country({
    required this.name,
    required this.capital,
    required this.currency,
    required this.iso2,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      capital: json['capital'],
      currency: json['currency'],
      iso2: json['iso2'],
    );
  }
}
