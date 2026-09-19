import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/seller_profile.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_state.dart';
import '../../widgets/speak_button.dart';
import '../../widgets/whole_word_text.dart';
import 'widgets/settings_scaffold.dart';
import '../../widgets/app_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final profile = state.profile;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.gutter,
          8,
          AppTheme.gutter,
          24,
        ),
        children: [
          _Header(profile: profile),
          const SizedBox(height: 22),
          SettingsRow(
            icon: Icons.person_outline,
            label: l10n.profileEditEntry,
            value: profile?.name,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
          ),
          SettingsRow(
            icon: Icons.auto_stories_outlined,
            label: l10n.profileStoryEntry,
            value: (profile?.craftStory?.trim().isNotEmpty ?? false)
                ? profile!.craftStory!.trim()
                : l10n.storyEmpty,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.craftStory),
          ),
          SettingsRow(
            icon: Icons.translate,
            label: l10n.profileLanguageEntry,
            value: state.language.endonym,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.changeLanguage),
          ),
          SettingsRow(
            icon: Icons.phone_outlined,
            label: l10n.profilePhoneEntry,
            value: profile?.phone ?? l10n.profileNotSet,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.changePhone),
          ),
          SettingsRow(
            icon: Icons.storefront_outlined,
            label: l10n.profileOndcEntry,
            value: (profile?.hasOndcAccount ?? false)
                ? l10n.ondcAccountLinked
                : l10n.ondcAccountNone,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.ondcAccount),
          ),
          SettingsRow(
            icon: Icons.notifications_none,
            label: l10n.profileNotificationsEntry,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.notifications),
          ),
          SettingsRow(
            icon: Icons.volume_up_outlined,
            label: l10n.profileVoiceEntry,
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.voiceSettings),
          ),
          SettingsRow(
            icon: Icons.shield_outlined,
            label: l10n.profilePrivacyEntry,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.privacy),
          ),
          SettingsRow(
            icon: Icons.sd_storage_outlined,
            label: l10n.profileStorageEntry,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.storage),
          ),
          SettingsRow(
            icon: Icons.help_outline,
            label: l10n.profileHelpEntry,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.help),
          ),
          SettingsRow(
            icon: Icons.logout,
            label: l10n.profileAccountEntry,
            tone: AppColors.danger,
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.account),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile});

  final SellerProfile? profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = profile?.name ?? l10n.profileNotSet;
    final village = profile?.village ?? l10n.profileNotSet;
    final craft = profile?.craft?.label(l10n) ?? l10n.profileNotSet;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Photo(path: profile?.photoPath),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WholeWordText(
                name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              _Fact(icon: Icons.place_outlined, text: village),
              _Fact(icon: Icons.handyman_outlined, text: craft),
            ],
          ),
        ),
        SpeakButton.lines(
          lines: [name, '${l10n.profileVillageLabel}: $village', craft],
          utteranceKey: 'screen:profile',
          size: 32,
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.muted),
          const SizedBox(width: 8),
          Expanded(
            child: WholeWordText(
              text,
              style: const TextStyle(
                fontSize: 17,
                height: 1.3,
                color: AppColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: AppColors.terracotta.withValues(alpha: 0.14),
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 46, color: AppColors.terracotta),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 84,
        height: 84,
        child: AppImage(
          path,
          decodeSize: 84,
          fadeIn: false,
          fallback: placeholder,
        ),
      ),
    );
  }
}
