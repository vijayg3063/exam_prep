import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/download_service.dart';
import '../../core/widgets/empty_state_widget.dart';

class DownloadsView extends ConsumerWidget {
  const DownloadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Offline Downloads Manager'),
      ),
      body: downloads.isEmpty
          ? const EmptyStateWidget(
              title: 'No Active or Saved Downloads',
              description: 'You can download videos and PDF notes to keep studying even when offline without internet.',
              icon: Icons.cloud_download_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: downloads.length,
              itemBuilder: (context, index) {
                final item = downloads[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: item.fileType == 'video' ? AppColors.lightPrimary : AppColors.errorLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                item.fileType == 'video' ? Icons.video_library_rounded : Icons.picture_as_pdf_rounded,
                                color: item.fileType == 'video' ? AppColors.primary : AppColors.error,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    '${item.courseTitle} • ${item.fileSizeText}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                              onPressed: () {
                                ref.read(downloadNotifierProvider.notifier).deleteDownload(item.id);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (!item.isCompleted) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Downloading...', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                              Text('${(item.progress * 100).toInt()}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: item.progress.clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: AppColors.border,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.successLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, size: 12, color: AppColors.success),
                                SizedBox(width: 4),
                                Text(
                                  'Ready to Watch Offline',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
