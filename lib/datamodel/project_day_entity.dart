
class ProjectDayEntity {
  final String id;
  final String text;
  final String prayer;
  final String projectId;
  final DateTime day;

  ProjectDayEntity({
    required this.id,
    required this.text,
    required this.prayer,
    required this.projectId,
    required this.day,
  });

  factory ProjectDayEntity.fromJson(Map<String, dynamic> json) {
    return ProjectDayEntity(
      id: json['id'],
      text: json['text'],
      prayer: json['prayer'],
      projectId: json['projectId'],
      day: DateTime.parse(json['day']),
    );
  }
}