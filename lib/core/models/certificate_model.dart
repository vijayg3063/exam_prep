class CertificateModel {
  final String id;
  final String certificateNumber;
  final String courseTitle;
  final String studentName;
  final DateTime issueDate;
  final String verificationUrl;

  const CertificateModel({
    required this.id,
    required this.certificateNumber,
    required this.courseTitle,
    required this.studentName,
    required this.issueDate,
    required this.verificationUrl,
  });
}
