class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String targetExam;
  final String preferredLanguage;
  final String? profilePicUrl;
  final int streakDays;
  final int totalStudyMinutes;
  final double averageAccuracy;
  final DateTime joinedDate;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.targetExam,
    required this.preferredLanguage,
    this.profilePicUrl,
    this.streakDays = 12,
    this.totalStudyMinutes = 2450,
    this.averageAccuracy = 82.5,
    required this.joinedDate,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? targetExam,
    String? preferredLanguage,
    String? profilePicUrl,
    int? streakDays,
    int? totalStudyMinutes,
    double? averageAccuracy,
    DateTime? joinedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      targetExam: targetExam ?? this.targetExam,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      streakDays: streakDays ?? this.streakDays,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}
