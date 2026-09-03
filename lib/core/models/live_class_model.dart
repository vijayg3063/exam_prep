enum LiveType { liveClass, doubtSession, liveTest }

class LiveClassModel {
  final String id;
  final String title;
  final String subject;
  final String courseTitle;
  final String instructorName;
  final DateTime scheduledAt;
  final String durationText;
  final bool isLiveNow;
  final bool isUpcoming;
  final bool reminderSet;
  final int activeViewers;
  final LiveType type;

  const LiveClassModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.courseTitle,
    required this.instructorName,
    required this.scheduledAt,
    required this.durationText,
    this.isLiveNow = false,
    this.isUpcoming = false,
    this.reminderSet = false,
    this.activeViewers = 0,
    required this.type,
  });

  LiveClassModel copyWith({
    bool? reminderSet,
    bool? isLiveNow,
    bool? isUpcoming,
    int? activeViewers,
  }) {
    return LiveClassModel(
      id: id,
      title: title,
      subject: subject,
      courseTitle: courseTitle,
      instructorName: instructorName,
      scheduledAt: scheduledAt,
      durationText: durationText,
      isLiveNow: isLiveNow ?? this.isLiveNow,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      reminderSet: reminderSet ?? this.reminderSet,
      activeViewers: activeViewers ?? this.activeViewers,
      type: type,
    );
  }
}

class ChatMessageModel {
  final String id;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isInstructor;

  const ChatMessageModel({
    required this.id,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isInstructor = false,
  });
}
