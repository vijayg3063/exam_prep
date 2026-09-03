import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/course_model.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/services/download_service.dart';

class VideoPlayerView extends ConsumerStatefulWidget {
  final CourseModel course;
  final LessonModel lesson;

  const VideoPlayerView({
    super.key,
    required this.course,
    required this.lesson,
  });

  @override
  ConsumerState<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends ConsumerState<VideoPlayerView> {
  bool _isPlaying = false;
  double _currentPositionSeconds = 0;
  double _playbackSpeed = 1.0;
  late LessonModel _currentLesson;

  @override
  void initState() {
    super.initState();
    _currentLesson = widget.lesson;
    _currentPositionSeconds = widget.lesson.watchPositionSeconds.toDouble();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _markCompleted() async {
    await ref.read(courseRepositoryProvider).markLessonCompleted(widget.course.id, _currentLesson.id);
    ref.invalidate(enrolledCoursesProvider);
    setState(() {
      _currentLesson = _currentLesson.copyWith(isCompleted: true);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Lesson marked as completed! Progress updated.')),
      );
    }
  }

  void _triggerDownload() {
    ref.read(downloadNotifierProvider.notifier).startDownload(
          _currentLesson.id,
          _currentLesson.title,
          widget.course.title,
          'video',
          '145 MB',
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📥 Download started! Check Progress in Downloads Manager.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxDuration = _currentLesson.durationSeconds > 0 ? _currentLesson.durationSeconds.toDouble() : 1800.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _currentLesson.title,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Simulated Video Screen Player
          Container(
            height: 230,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video Screen Overlay
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isPlaying ? Icons.play_circle_filled_rounded : Icons.pause_circle_filled_rounded,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isPlaying ? 'Playing at ${_playbackSpeed}x' : 'Paused',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Controls Overlay
                GestureDetector(
                  onTap: _togglePlayPause,
                  behavior: HitTestBehavior.opaque,
                ),

                // Bottom Control Bar (Seek bar + Duration + Speed)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.white30,
                            thumbColor: AppColors.primary,
                          ),
                          child: Slider(
                            value: _currentPositionSeconds.clamp(0.0, maxDuration),
                            max: maxDuration,
                            onChanged: (val) {
                              setState(() {
                                _currentPositionSeconds = val;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(_currentPositionSeconds / 60).floor()}:${(_currentPositionSeconds % 60).floor().toString().padLeft(2, '0')} / ${_currentLesson.durationText}',
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            Row(
                              children: [
                                // Speed Selector
                                PopupMenuButton<double>(
                                  initialValue: _playbackSpeed,
                                  onSelected: (speed) {
                                    setState(() {
                                      _playbackSpeed = speed;
                                    });
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(value: 1.0, child: Text('1.0x Normal')),
                                    PopupMenuItem(value: 1.25, child: Text('1.25x Speed')),
                                    PopupMenuItem(value: 1.5, child: Text('1.5x Speed')),
                                    PopupMenuItem(value: 2.0, child: Text('2.0x Speed')),
                                  ],
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${_playbackSpeed}x',
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 20),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Action Toolbar (Complete, Download, Bookmark)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  onPressed: _markCompleted,
                  icon: Icon(
                    _currentLesson.isCompleted ? Icons.check_circle_rounded : Icons.circle_outlined,
                    color: _currentLesson.isCompleted ? AppColors.success : AppColors.primary,
                    size: 18,
                  ),
                  label: Text(_currentLesson.isCompleted ? 'Completed' : 'Mark Complete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _currentLesson.isCompleted ? AppColors.success : AppColors.primary,
                    side: BorderSide(color: _currentLesson.isCompleted ? AppColors.success : AppColors.primary),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _triggerDownload,
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Download Offline'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border_rounded, color: AppColors.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lesson bookmarked for quick revision.')),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Lesson Details & Resources Tabs
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    tabs: [
                      Tab(text: 'Lesson Notes & PDFs'),
                      Tab(text: 'Course Curriculum'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: Class Notes
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Attached Resources',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 10),
                              Card(
                                child: ListTile(
                                  leading: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 28),
                                  title: Text('${_currentLesson.title} Notes'),
                                  subtitle: const Text('High Yield PDF Notes & Formula Sheet • 4.2 MB'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.visibility_rounded, color: AppColors.primary),
                                    onPressed: () {
                                      context.push('/notes-viewer', extra: '${_currentLesson.title} Class Notes');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tab 2: Course Curriculum list
                        ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: widget.course.chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = widget.course.chapters[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chapter.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                ...chapter.lessons.map((l) {
                                  final isSel = l.id == _currentLesson.id;
                                  return ListTile(
                                    selected: isSel,
                                    selectedTileColor: AppColors.lightPrimary,
                                    dense: true,
                                    leading: Icon(
                                      l.isCompleted ? Icons.check_circle_rounded : Icons.play_circle_fill_rounded,
                                      color: l.isCompleted ? AppColors.success : AppColors.primary,
                                    ),
                                    title: Text(l.title, style: const TextStyle(fontSize: 13)),
                                    subtitle: Text(l.durationText, style: const TextStyle(fontSize: 11)),
                                    onTap: () {
                                      setState(() {
                                        _currentLesson = l;
                                        _currentPositionSeconds = l.watchPositionSeconds.toDouble();
                                      });
                                    },
                                  );
                                }),
                                const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
