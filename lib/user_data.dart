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
    // Add the donation to the donations list
    donations.add({
      'projectTitle': projectTitle,
      'day': day,
      'amount': amount,
    });

    // Update the total donations for the project
    if (totalDonationsPerProject.containsKey(projectTitle)) {
      totalDonationsPerProject[projectTitle] =
          totalDonationsPerProject[projectTitle]! + amount;
    } else {
      totalDonationsPerProject[projectTitle] = amount;
    }

    // Add the project to activeProjects if not already present
    if (!activeProjects.contains(projectTitle)) {
      activeProjects.add(projectTitle);
    }
  }

  // Remove a donation from a project
  void removeDonation(String projectTitle, String day) {
    // Find the donation to remove
    final donation = donations.firstWhere(
      (d) => d['projectTitle'] == projectTitle && d['day'] == day,
      orElse: () => {},
    );

    if (donation.isNotEmpty) {
      // Subtract the amount from the total donations for the project
      final amount = donation['amount'] as double;
      totalDonationsPerProject[projectTitle] =
          totalDonationsPerProject[projectTitle]! - amount;

      // Remove the donation from the donations list
      donations.remove(donation);

      // If the total donations for the project are now 0, remove it from activeProjects
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

final List<User> users = [
  User(
    id: '1',
    name: 'Alice Johnson',
    email: 'alice@example.com',
    donations: [
      {
        'projectTitle': 'Clean Water Initiative',
        'day': '2025-04-01',
        'amount': 50.0,
      },
      {
        'projectTitle': 'Education for All',
        'day': '2025-04-02',
        'amount': 75.0,
      },
    ],
    activeProjects: ['Clean Water Initiative', 'Education for All'],
    totalDonationsPerProject: {
      'Clean Water Initiative': 50.0,
      'Education for All': 75.0,
    },
  ),
  User(
    id: '2',
    name: 'Bob Smith',
    email: 'bob@example.com',
    donations: [
      {
        'projectTitle': 'Healthcare Access',
        'day': '2025-04-03',
        'amount': 100.0,
      },
    ],
    activeProjects: ['Healthcare Access'],
    totalDonationsPerProject: {
      'Healthcare Access': 100.0,
    },
  ),
];