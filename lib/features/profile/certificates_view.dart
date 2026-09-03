import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/mock_data.dart';
import '../../core/widgets/empty_state_widget.dart';

class CertificatesView extends StatelessWidget {
  const CertificatesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Course Completion Certificates 🏆'),
      ),
      body: MockData.certificates.isEmpty
          ? const EmptyStateWidget(
              title: 'No Certificates Earned Yet',
              description: 'Complete 100% of any course lessons and quizzes to earn verified certificates.',
              icon: Icons.workspace_premium_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: MockData.certificates.length,
              itemBuilder: (context, index) {
                final cert = MockData.certificates[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.lightPrimary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.workspace_premium_rounded, color: AppColors.primary, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cert.courseTitle,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  Text(
                                    'Certificate ID: ${cert.certificateNumber}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: AppColors.border),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Issued to: ${cert.studentName}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            Text(
                              cert.issueDate.toString().split(' ')[0],
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Downloading Certificate PDF (${cert.certificateNumber})...')),
                              );
                            },
                            icon: const Icon(Icons.download_rounded, size: 18),
                            label: const Text('Download PDF Certificate'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
