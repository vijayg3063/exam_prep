import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _liveReminders = true;
  bool _testAlerts = true;
  bool _downloadOnWifiOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Application Settings ⚙️'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('NOTIFICATIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Live Class Reminders'),
            subtitle: const Text('Get alerts 15 minutes before scheduled live sessions'),
            value: _liveReminders,
            activeTrackColor: AppColors.primary,
            onChanged: (val) => setState(() => _liveReminders = val),
          ),
          SwitchListTile(
            title: const Text('Test Series & Result Alerts'),
            subtitle: const Text('Receive instant scorecard notifications after test evaluation'),
            value: _testAlerts,
            activeTrackColor: AppColors.primary,
            onChanged: (val) => setState(() => _testAlerts = val),
          ),
          const Divider(height: 24, color: AppColors.border),
          const Text('DOWNLOADS & DATA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Download over Wi-Fi only'),
            subtitle: const Text('Prevent large video downloads over mobile cellular data'),
            value: _downloadOnWifiOnly,
            activeTrackColor: AppColors.primary,
            onChanged: (val) => setState(() => _downloadOnWifiOnly = val),
          ),
          ListTile(
            title: const Text('Clear Cached Video Data'),
            subtitle: const Text('Free up local storage space on device'),
            trailing: const Text('42 MB', style: TextStyle(color: AppColors.textMuted)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cached data cleared successfully.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
