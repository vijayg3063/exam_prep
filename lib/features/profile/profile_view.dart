import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/auth_repository.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authNotifierProvider);
    final user = userAsync.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Student Profile 👤'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'V',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? 'Vijay Gurjar',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'vijay.gurjar@example.com',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.lightPrimary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Target: ${user?.targetExam ?? "SSC CGL 2026"}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                    onPressed: () => context.push('/exam-onboarding'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Statistics Grid (Study Hours, Streak, Accuracy, Completed)
            Row(
              children: [
                _buildStatTile('Study Hours', '${((user?.totalStudyMinutes ?? 2450) / 60).round()}h', Icons.timer_outlined, AppColors.primary),
                const SizedBox(width: 10),
                _buildStatTile('Streak', '🔥 ${user?.streakDays ?? 12}d', Icons.local_fire_department_rounded, AppColors.streakOrange),
                const SizedBox(width: 10),
                _buildStatTile('Accuracy', '${user?.averageAccuracy ?? 82.5}%', Icons.analytics_outlined, AppColors.success),
              ],
            ),
            const SizedBox(height: 24),

            // Section 1: Learning Resources
            const Text('MY LEARNING & CONTENT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            _buildMenuItem(context, Icons.menu_book_rounded, 'My Enrolled Courses', () => context.push('/my-learning')),
            _buildMenuItem(context, Icons.download_for_offline_rounded, 'Offline Downloads', () => context.push('/downloads')),
            _buildMenuItem(context, Icons.bookmark_border_rounded, 'My Bookmarks & Questions', () => context.push('/bookmarks')),
            _buildMenuItem(context, Icons.workspace_premium_rounded, 'My Certificates', () => context.push('/certificates')),

            const SizedBox(height: 20),
            // Section 2: Performance & Test Results
            const Text('PERFORMANCE ANALYTICS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            _buildMenuItem(context, Icons.insert_chart_outlined_rounded, 'Test History & Scorecard', () => context.push('/test-result')),
            _buildMenuItem(context, Icons.track_changes_rounded, 'Study Goals & Progress', () => context.push('/home')),

            const SizedBox(height: 20),
            // Section 3: Account & Support
            const Text('ACCOUNT & PREFERENCES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            _buildMenuItem(context, Icons.notifications_none_rounded, 'Notifications Center', () => context.push('/notifications')),
            _buildMenuItem(context, Icons.translate_rounded, 'Change Language & Exam', () => context.push('/exam-onboarding')),
            _buildMenuItem(context, Icons.help_outline_rounded, 'Help & Support', () {}),
            _buildMenuItem(context, Icons.logout_rounded, 'Logout Account', () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            }, isDestructive: true),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.primary, size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}
