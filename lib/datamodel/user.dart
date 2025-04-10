class User {
  final String id;
  final String name;
  final String email;
  final List<Map<String, dynamic>> donations;
  final List<String> activeProjects; // List of active project titles
  final Map<String, double> totalDonationsPerProject; // Total donations per project

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.donations,
    required this.activeProjects,
    required this.totalDonationsPerProject,
  });

  // Add a donation to a project
  void addDonation(String projectTitle, String day, double amount) {
    donations.add({
      'projectTitle': projectTitle,
      'day': day,
      'amount': amount,
    });

    totalDonationsPerProject[projectTitle] =
        (totalDonationsPerProject[projectTitle] ?? 0.0) + amount;

    if (!activeProjects.contains(projectTitle)) {
      activeProjects.add(projectTitle);
    }
  }

  // Remove a donation from a project
  void removeDonation(String projectTitle, String day) {
    final donation = donations.firstWhere(
      (d) => d['projectTitle'] == projectTitle && d['day'] == day,
      orElse: () => {},
    );

    if (donation.isNotEmpty) {
      final amount = donation['amount'] as double;
      totalDonationsPerProject[projectTitle] =
          totalDonationsPerProject[projectTitle]! - amount;

      donations.remove(donation);

      if (totalDonationsPerProject[projectTitle]! <= 0) {
        totalDonationsPerProject.remove(projectTitle);
        activeProjects.remove(projectTitle);
      }
    }
  }

  // Get the total donations for a specific project
  double getTotalDonationsForProject(String projectTitle) {
    return totalDonationsPerProject[projectTitle] ?? 0.0;
  }
}
