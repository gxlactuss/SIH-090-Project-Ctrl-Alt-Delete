import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/speak_button.dart';
import '../profile/widgets/settings_scaffold.dart';
import '../../widgets/whole_word_text.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key, this.version});

  final String? version;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late String? _version = widget.version;

  @override
  void initState() {
    super.initState();
    if (_version == null) _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _version = '${info.version} (${info.buildNumber})');
      }
    } catch (_) {
      if (mounted) setState(() => _version = '-');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final version = _version ?? '…';

    final sections = <({String title, String body})>[
      (title: l10n.aboutWhatTitle, body: l10n.aboutWhat),
      (title: l10n.aboutWhyTitle, body: l10n.aboutWhy),
      (title: l10n.aboutHowTitle, body: l10n.aboutHow),
      (title: l10n.aboutSihTitle, body: l10n.aboutSih),
    ];

    return SettingsScaffold(
      title: l10n.aboutTitle,
      spokenLines: [
        l10n.aboutTitle,
        l10n.aboutMission,
        for (final section in sections) ...[section.title, section.body],
        l10n.versionNumber(version),
      ],
      rows: [
        _Mission(text: l10n.aboutMission, label: l10n.aboutMissionTitle),
        const SizedBox(height: 22),
        for (final section in sections) ...[
          _Section(title: section.title, body: section.body),
          const SizedBox(height: 20),
        ],
        SettingsRow(
          icon: Icons.gavel_outlined,
          label: l10n.helpTermsEntry,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.terms),
        ),
        SettingsRow(
          icon: Icons.description_outlined,
          label: l10n.versionLicences,
          value: l10n.versionLicencesWhy,
          onTap: () => showLicensePage(
            context: context,
            applicationName: l10n.appTitle,
            applicationVersion: version,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.phone_android, size: 24, color: AppColors.muted),
            const SizedBox(width: 10),
            Expanded(
              child: WholeWordText(
                l10n.versionNumber(version),
                style: const TextStyle(fontSize: 17, color: AppColors.muted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Mission extends StatelessWidget {
  const _Mission({required this.text, required this.label});

  final String text;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.terracotta.withValues(alpha: 0.10),
        border: Border.all(color: AppColors.terracotta, width: 2),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: WholeWordText(
                  label,
                  style: const TextStyle(
                    fontSize: AppTheme.minTextSize,
                    fontWeight: FontWeight.w600,
                    color: AppColors.terracotta,
                  ),
                ),
              ),
              SpeakButton(text: text, size: 30),
            ],
          ),
          const SizedBox(height: 8),
          WholeWordText(
            text,
            style: const TextStyle(
              fontSize: 24,
              height: 1.4,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: WholeWordText(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SpeakButton.lines(lines: [title, body], size: 28),
          ],
        ),
        const SizedBox(height: 6),
        WholeWordText(
          body,
          style: const TextStyle(
            fontSize: 18,
            height: 1.5,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
