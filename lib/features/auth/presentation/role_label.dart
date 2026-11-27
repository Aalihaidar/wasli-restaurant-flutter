import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_role.dart';

/// The name of [role] in the active language.
String roleLabel(AppLocalizations l10n, StaffRole role) => switch (role) {
  StaffRole.admin => l10n.roleAdmin,
  StaffRole.cashier => l10n.roleCashier,
  StaffRole.unknown => l10n.roleUnknown,
};
