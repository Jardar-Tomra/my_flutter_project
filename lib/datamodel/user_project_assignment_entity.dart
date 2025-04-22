import 'dart:convert';

class UserProjectAssignmentEntity {
  final String userId;
  final String projectId;
  final double dailyDonationAmount;
  final List<String> participants; // Replaced peopleInHousehold with participants

  UserProjectAssignmentEntity({
    required this.userId,
    required this.projectId,
    required this.dailyDonationAmount,
    required this.participants,
  });

  factory UserProjectAssignmentEntity.fromJson(Map<String, dynamic> json) {
    return UserProjectAssignmentEntity(
      userId: json['userId'],
      projectId: json['projectId'],
      dailyDonationAmount: json['dailyDonationAmount'],
      participants: List<String>.from(json['participants']), // Deserialize participants
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'projectId': projectId,
      'dailyDonationAmount': dailyDonationAmount,
      'participants': participants, // Serialize participants
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
