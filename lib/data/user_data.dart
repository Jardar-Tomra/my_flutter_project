import 'package:my_flutter_project/datamodel/user.dart';

final List<User> users = [
  User(
    id: '1',
    name: 'Alice Johnson',
    email: 'alice@example.com',
    donations: [
      {
        'projectTitle': 'Clean Water Initiative',
        'day': '2025-01-01',
        'amount': 50.0,
      },
      {
        'projectTitle': 'Education for All',
        'day': '2025-01-05',
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