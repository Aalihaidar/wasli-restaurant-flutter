/// The restaurant a member works for, as the server describes it.
class StaffRestaurant {
  /// Creates the restaurant.
  const new({
    required this.slug,
    required this.nameEn,
    required this.nameAr,
    required this.latitude,
    required this.longitude,
    required this.currency,
    this.logoUrl,
    this.serviceRadiusMeters,
  });

  /// The unique short name used in the restaurant's links.
  final String slug;

  /// The name in English.
  final String nameEn;

  /// The name in Arabic.
  final String nameAr;

  /// The absolute address of the logo, or `null` when the restaurant has none.
  final String? logoUrl;

  /// Where the restaurant is.
  final double latitude;

  /// Where the restaurant is.
  final double longitude;

  /// The distance in metres within which a customer counts as at the restaurant, or `null` when none is set.
  final int? serviceRadiusMeters;

  /// The currency of the prices (always `AED` today).
  final String currency;

  /// The name in the language with [languageCode]: Arabic for `ar`, English for anything else.
  String nameIn(String languageCode) => languageCode == 'ar' ? nameAr : nameEn;
}
