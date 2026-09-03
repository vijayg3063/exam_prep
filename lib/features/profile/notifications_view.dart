import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/mock_data.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifications Center 🔔'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.notifications.length,
        itemBuilder: (context, index) {
          final notif = MockData.notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 20),
              ),
              title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: Text(notif.message, style: const TextStyle(fontSize: 12)),
              onTap: () {
                if (notif.route != null) {
                  context.push(notif.route!);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
