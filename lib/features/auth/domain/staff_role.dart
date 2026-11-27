/// What a member of a restaurant is. The server decides what each role may do; the app only labels it.
enum StaffRole {
  /// The restaurant's administrator: every permission.
  admin,

  /// A cashier: sees and decides orders.
  cashier,

  /// A role this version of the app does not know. It is shown with a neutral label.
  unknown;

  /// The role of the server's [code] (`admin` or `cashier`); any other code is [unknown].
  static StaffRole fromCode(String code) => switch (code) {
    'admin' => admin,
    'cashier' => cashier,
    _ => unknown,
  };
}
