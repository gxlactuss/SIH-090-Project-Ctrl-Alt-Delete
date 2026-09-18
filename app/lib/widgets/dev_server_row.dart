import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import '../core/di.dart';
import '../core/dev/dev_accounts.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../data/remote/backend_session.dart';
import '../data/remote/server_check.dart';
import 'whole_word_text.dart';

class DevServerRow extends StatefulWidget {
  const DevServerRow({super.key, this.check});

  final ServerCheck? check;

  @override
  State<DevServerRow> createState() => _DevServerRowState();
}

class _DevServerRowState extends State<DevServerRow> {
  bool _running = false;
  ServerCheckResult? _result;

  Future<void> _run() async {
    final check =
        widget.check ??
        ServerCheck(
          baseUrl: AppConfig.apiBaseUrl,
          session: context.maybeRead<BackendSession>(),
        );
    setState(() => _running = true);
    final result = await check.run();
    if (!mounted) return;
    setState(() {
      _running = false;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!DevAccounts.enabled || kReleaseMode) return const SizedBox.shrink();
    if (widget.check == null && !AppConfig.hasBackend) {
      return const SizedBox.shrink();
    }

    final calls = AppConfig.apiRealCalls.isEmpty
        ? 'all'
        : AppConfig.apiRealCalls;
    final result = _result;
    final text = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: AppColors.muted);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: _running ? null : _run,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppTheme.minTapTarget),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            border: Border.all(color: AppColors.muted, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(switch (result?.reachable) {
                    true => Icons.cloud_done_outlined,
                    false => Icons.cloud_off_outlined,
                    null => Icons.dns_outlined,
                  }, color: AppColors.muted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: WholeWordText(
                      _running ? 'Checking server…' : 'Tap to check server',
                      style: text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              WholeWordText(AppConfig.apiBaseUrl, style: text),
              WholeWordText('real calls: $calls', style: text),
              if (result != null)
                for (final line in result.lines)
                  WholeWordText(line, style: text),
            ],
          ),
        ),
      ),
    );
  }
}
