import 'dart:convert';

class UserProjectAssignmentEntity {
  final String userId;
  final String projectId;

  UserProjectAssignmentEntity({
    required this.userId,
    required this.projectId,
  });

  factory UserProjectAssignmentEntity.fromJson(Map<String, dynamic> json) {
    return UserProjectAssignmentEntity(
      userId: json['userId'],
      projectId: json['projectId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'projectId': projectId,
    };
  }

  static List<UserProjectAssignmentEntity> fromJsonList(String jsonString) {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((data) => UserProjectAssignmentEntity.fromJson(data)).toList();
  }

  static String toJsonList(List<UserProjectAssignmentEntity> assignments) {
    final List<Map<String, dynamic>> jsonData =
        assignments.map((assignment) => assignment.toJson()).toList();
    return jsonEncode(jsonData);
  }
}
