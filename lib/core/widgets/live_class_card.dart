import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/live_class_model.dart';
import '../theme/app_colors.dart';

class LiveClassCard extends StatelessWidget {
  final LiveClassModel liveClass;
  final VoidCallback onTap;
  final VoidCallback? onReminderToggle;

  const LiveClassCard({
    super.key,
    required this.liveClass,
    required this.onTap,
    this.onReminderToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: liveClass.isLiveNow ? AppColors.error : AppColors.border,
          width: liveClass.isLiveNow ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (liveClass.isLiveNow)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: AppColors.liveIndicator, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'LIVE NOW',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.liveIndicator,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.lightPrimary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        DateFormat('EEE, d MMM • h:mm a').format(liveClass.scheduledAt),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      liveClass.subject,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                liveClass.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.person, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    liveClass.instructorName,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.school, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      liveClass.courseTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (liveClass.isLiveNow)
                    Row(
                      children: [
                        const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.error),
                        const SizedBox(width: 4),
                        Text(
                          '${liveClass.activeViewers} Watching',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Duration: ${liveClass.durationText}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  if (liveClass.isLiveNow)
                    ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Join Class'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  else if (onReminderToggle != null)
                    OutlinedButton.icon(
                      onPressed: onReminderToggle,
                      icon: Icon(
                        liveClass.reminderSet ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                        size: 16,
                        color: liveClass.reminderSet ? AppColors.success : AppColors.primary,
                      ),
                      label: Text(
                        liveClass.reminderSet ? 'Reminder Set' : 'Set Reminder',
                        style: TextStyle(
                          fontSize: 12,
                          color: liveClass.reminderSet ? AppColors.success : AppColors.primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(110, 36),
                        side: BorderSide(color: liveClass.reminderSet ? AppColors.success : AppColors.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
