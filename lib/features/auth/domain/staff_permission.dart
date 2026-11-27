/// One thing a member may do, as the server reports it. The app hides or disables what is missing, and the server
/// stays the authority (`403 permission_denied`).
enum StaffPermission {
  /// See the restaurant's orders (`orders.view`).
  ordersView('orders.view'),

  /// Accept or reject an order (`orders.decide`).
  ordersDecide('orders.decide'),

  /// Edit the menu (`menu.edit`).
  menuEdit('menu.edit'),

  /// Manage the restaurant's members (`members.manage`).
  membersManage('members.manage'),

  /// Change the restaurant's settings (`restaurant.settings`).
  restaurantSettings('restaurant.settings'),

  /// See reports (`reports.view`).
  reportsView('reports.view'),

  /// A permission this version of the app does not know.
  unknown('');

  new(this.code);

  /// The code the server uses.
  final String code;

  /// The permission of the server's [code], or [unknown].
  static StaffPermission fromCode(String code) =>
      values.firstWhere((permission) => permission.code == code && code.isNotEmpty, orElse: () => unknown);
}
