class ProjectDayEntity {
  final String id;
  final String title;
  final String prayer;
  final String projectId;
  final DateTime day;
  final String story;

  ProjectDayEntity({
    required this.id,
    required this.title,
    required this.prayer,
    required this.projectId,
    required this.day,
    required this.story,
  });

  factory ProjectDayEntity.fromJson(Map<String, dynamic> json) {
    return ProjectDayEntity(
      id: json['id'],
      title: json['text'],
      prayer: json['prayer'],
      projectId: json['projectId'],
      day: DateTime.parse(json['day']),
      story: json['story'],
    );
  }
}