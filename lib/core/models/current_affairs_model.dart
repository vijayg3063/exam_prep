class CurrentAffairsModel {
  final String id;
  final String title;
  final String category;
  final String summary;
  final List<String> keyTakeaways;
  final String examRelevance;
  final DateTime publishedDate;
  final String imageUrl;
  final bool isBookmarked;

  const CurrentAffairsModel({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.keyTakeaways,
    required this.examRelevance,
    required this.publishedDate,
    required this.imageUrl,
    this.isBookmarked = false,
  });

  CurrentAffairsModel copyWith({bool? isBookmarked}) {
    return CurrentAffairsModel(
      id: id,
      title: title,
      category: category,
      summary: summary,
      keyTakeaways: keyTakeaways,
      examRelevance: examRelevance,
      publishedDate: publishedDate,
      imageUrl: imageUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
