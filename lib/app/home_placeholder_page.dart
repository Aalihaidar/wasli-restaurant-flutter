import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wasli_restaurant/core/l10n/l10n.dart';
import 'package:wasli_restaurant/features/auth/application/auth_providers.dart';
import 'package:wasli_restaurant/features/auth/presentation/role_label.dart';
import 'package:wasli_restaurant/theme/design_tokens.dart';
import 'package:wasli_restaurant/theme/wasli_theme.dart';

/// The first page after signing in, until the orders list exists: the restaurant, who is signed in, and the sign-out
/// button.
class HomePlaceholderPage extends ConsumerWidget {
  /// Creates the page.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider.select((state) => state.value));
    if (session == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: WasliSpacing.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.restaurant.nameIn(Localizations.localeOf(context).languageCode),
            style: context.wasliText.heading2,
          ),
          const SizedBox(height: WasliSpacing.space2),
          Text(l10n.homeSignedInAs(name: session.fullName), style: context.wasliText.body),
          Text(roleLabel(l10n, session.role), style: context.wasliText.bodySmall),
          const SizedBox(height: WasliSpacing.space5),
          OutlinedButton(onPressed: () => ref.read(sessionProvider.notifier).signOut(), child: Text(l10n.signOut)),
        ],
      ),
    );
  }
}
