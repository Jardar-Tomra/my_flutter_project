
class DonationEntity {
  final String id;
  final String userId;
  final String projectId;
  final String projectDayId;
  final DateTime date;
  final double amount;

  DonationEntity({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.projectDayId,
    required this.date,
    required this.amount,
  });

  factory DonationEntity.fromJson(Map<String, dynamic> json) {
    return DonationEntity(
      id: json['id'],
      userId: json['userId'],
      projectId: json['projectId'],
      projectDayId: json['projectDayId'],
      date: DateTime.parse(json['date']),
      amount: json['amount'],
    );
  }
}