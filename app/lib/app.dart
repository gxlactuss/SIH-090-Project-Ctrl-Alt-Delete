import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_routes.dart';
import 'core/di.dart';
import 'core/routing/link_router.dart';
import 'core/theme/app_background.dart';
import 'core/theme/app_theme.dart';
import 'data/models/app_language.dart';
import 'data/models/listing.dart';
import 'features/capture/capture_screen.dart';
import 'features/onboarding/language_screen.dart';
import 'features/onboarding/ondc_screen.dart';
import 'features/onboarding/otp_screen.dart';
import 'features/onboarding/permissions_screen.dart';
import 'features/onboarding/phone_screen.dart';
import 'features/onboarding/practice_screen.dart';
import 'features/onboarding/profile_screen.dart';
import 'features/onboarding/splash_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/onboarding/terms_agree_screen.dart';
import 'features/queue/queue_item_screen.dart';
import 'features/listings/listing_detail_screen.dart';
import 'features/help/about_screen.dart';
import 'features/help/faq_screen.dart';
import 'features/help/help_content.dart';
import 'features/help/help_screen.dart';
import 'features/help/help_topic_screen.dart';
import 'features/help/support_screen.dart';
import 'features/help/terms_screen.dart';
import 'features/profile/account_screen.dart';
import 'features/system/force_update_screen.dart';
import 'features/system/permission_recovery_screen.dart';
import 'features/profile/change_phone_screen.dart';
import 'features/profile/craft_story_screen.dart';
import 'features/profile/edit_profile_screen.dart';
import 'features/profile/notifications_screen.dart';
import 'features/profile/ondc_account_screen.dart';
import 'features/profile/privacy_screen.dart';
import 'features/profile/storage_screen.dart';
import 'features/profile/voice_settings_screen.dart';
import 'features/queue/queue_screen.dart';
import 'features/review/review_screen.dart';
import 'features/sales/earnings_screen.dart';
import 'features/sales/packing_screen.dart';
import 'features/sales/sale_detail_screen.dart';
import 'features/shell/app_shell.dart';
import 'l10n/app_localizations.dart';
import 'state/app_state.dart';
import 'state/review_controller.dart';
import 'services/update_service.dart';

class KaarigarApp extends StatelessWidget {
  const KaarigarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final language = context.select<AppState, AppLanguage>((s) => s.language);
    final router = context.maybeRead<LinkRouter>();

    return MaterialApp(
      title: 'Kaarigar',
      debugShowCheckedModeBanner: false,
      navigatorKey: router?.navigatorKey,
      theme: AppTheme.forLanguage(language),
      builder: (context, child) {
        return MediaQuery.withClampedTextScaling(
          minScaleFactor: 1.0,
          maxScaleFactor: 2.0,
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final grow = MediaQuery.textScalerOf(context).scale(20) - 20;
              return Theme(
                data: theme.copyWith(
                  appBarTheme: theme.appBarTheme.copyWith(
                    toolbarHeight: AppTheme.minTapTarget + grow,
                  ),
                ),
                child: AppBackground(child: child ?? const SizedBox.shrink()),
              );
            },
          ),
        );
      },
      locale: language.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLanguage.locales,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.language: (_) => const LanguageScreen(),
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.termsAgree: (_) => const TermsAgreeScreen(),
        AppRoutes.permissions: (_) => const PermissionsScreen(),
        AppRoutes.phone: (_) => const PhoneScreen(),
        AppRoutes.otp: (_) => const OtpScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.ondc: (_) => const OndcScreen(),
        AppRoutes.practice: (_) => const PracticeScreen(),
        AppRoutes.home: (_) => const AppShell(),
        AppRoutes.capture: (_) => const CaptureScreen(),
        AppRoutes.queue: (_) => const QueueScreen(),
        AppRoutes.earnings: (_) => const EarningsScreen(),
        AppRoutes.editProfile: (_) => const EditProfileScreen(),
        AppRoutes.craftStory: (_) => const CraftStoryScreen(),
        AppRoutes.changeLanguage: (_) => const LanguageScreen(isChange: true),
        AppRoutes.changePhone: (_) => const ChangePhoneScreen(),
        AppRoutes.ondcAccount: (_) => const OndcAccountScreen(),
        AppRoutes.notifications: (_) => const NotificationsScreen(),
        AppRoutes.voiceSettings: (_) => const VoiceSettingsScreen(),
        AppRoutes.privacy: (_) => const PrivacyScreen(),
        AppRoutes.storage: (_) => const StorageScreen(),
        AppRoutes.account: (_) => const AccountScreen(),
        AppRoutes.help: (_) => const HelpScreen(),
        AppRoutes.practiceReplay: (_) => const PracticeScreen(isReplay: true),
        AppRoutes.faq: (_) => const FaqScreen(),
        AppRoutes.about: (_) => const AboutScreen(),
        AppRoutes.support: (_) => const SupportScreen(),
        AppRoutes.terms: (_) => const TermsScreen(),
        AppRoutes.permissionRecovery: (_) => const PermissionRecoveryScreen(),
        AppRoutes.forceUpdate: (context) => ForceUpdateScreen(
          storeUrl: context.maybeRead<UpdateService>()?.storeUrl,
        ),
      },
      onGenerateRoute: (settings) {
        final argument = settings.arguments;
        if (settings.name == AppRoutes.review && argument is Listing) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ReviewScreen(listing: argument),
          );
        }
        if (settings.name == AppRoutes.review &&
            argument is (Listing, ReviewStage)) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) =>
                ReviewScreen(listing: argument.$1, initialStage: argument.$2),
          );
        }
        if (settings.name == AppRoutes.listing && argument is Listing) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ListingDetailScreen(listing: argument),
          );
        }
        final id = argument;
        if (id is! String) return null;
        if (settings.name == AppRoutes.helpTopic) {
          final topic = HelpTopic.values.where((t) => t.name == id).firstOrNull;
          if (topic == null) return null;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => HelpTopicScreen(topic: topic),
          );
        }
        return switch (settings.name) {
          AppRoutes.capture => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => CaptureScreen(templateListingId: id),
          ),
          AppRoutes.sale => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => SaleDetailScreen(saleId: id),
          ),
          AppRoutes.packing => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => PackingScreen(saleId: id),
          ),
          AppRoutes.queueItem => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => QueueItemScreen(captureId: id),
          ),
          _ => null,
        };
      },
    );
  }
}
