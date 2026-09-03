import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadItem {
  final String id;
  final String title;
  final String courseTitle;
  final String fileType; // 'video' or 'pdf'
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  final String fileSizeText;

  const DownloadItem({
    required this.id,
    required this.title,
    required this.courseTitle,
    required this.fileType,
    required this.progress,
    required this.isCompleted,
    required this.fileSizeText,
  });

  DownloadItem copyWith({
    double? progress,
    bool? isCompleted,
  }) {
    return DownloadItem(
      id: id,
      title: title,
      courseTitle: courseTitle,
      fileType: fileType,
      progress: progress ?? this.progress,
      isCompleted: isCompleted ?? this.isCompleted,
      fileSizeText: fileSizeText,
    );
  }
}

class DownloadNotifier extends StateNotifier<List<DownloadItem>> {
  DownloadNotifier() : super([
    const DownloadItem(
      id: 'l_01',
      title: 'Lesson 01: Basics of Percentage & Fraction Conversion',
      courseTitle: 'SSC CGL Complete Quantitative Aptitude Masterclass',
      fileType: 'video',
      progress: 1.0,
      isCompleted: true,
      fileSizeText: '145 MB',
    ),
    const DownloadItem(
      id: 'pdf_01',
      title: 'Percentage Masterclass Class Notes PDF',
      courseTitle: 'SSC CGL Complete Quantitative Aptitude Masterclass',
      fileType: 'pdf',
      progress: 1.0,
      isCompleted: true,
      fileSizeText: '14.2 MB',
    ),
  ]);

  void startDownload(String id, String title, String courseTitle, String fileType, String sizeText) {
    if (state.any((item) => item.id == id)) return;

    final newItem = DownloadItem(
      id: id,
      title: title,
      courseTitle: courseTitle,
      fileType: fileType,
      progress: 0.1,
      isCompleted: false,
      fileSizeText: sizeText,
    );

    state = [...state, newItem];
    _simulateDownload(id);
  }

  void _simulateDownload(String id) async {
    for (int i = 2; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      state = [
        for (final item in state)
          if (item.id == id)
            item.copyWith(
              progress: i / 10.0,
              isCompleted: i == 10,
            )
          else
            item
      ];
    }
  }

  void deleteDownload(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final downloadNotifierProvider = StateNotifierProvider<DownloadNotifier, List<DownloadItem>>((ref) {
  return DownloadNotifier();
});
