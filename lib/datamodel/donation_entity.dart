class DonationEntity {
  final String id;
  final String userId;
  final String projectId;
  final String projectDayId;
  final DateTime date;
  final double amount;
  final String donator; // Add participantName field

  DonationEntity({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.projectDayId,
    required this.date,
    required this.amount,
    required this.donator, // Initialize participantName
  });

  factory DonationEntity.fromJson(Map<String, dynamic> json) {
    return DonationEntity(
      id: json['id'],
      userId: json['userId'],
      projectId: json['projectId'],
      projectDayId: json['projectDayId'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      donator: json['donator'], // Deserialize participantName
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'projectId': projectId,
      'projectDayId': projectDayId,
      'date': date.toIso8601String(),
      'amount': amount,
      'participantName': donator, // Serialize participantName
    };
  }
}