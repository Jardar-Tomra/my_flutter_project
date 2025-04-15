import 'package:flutter/material.dart';
import 'package:my_flutter_project/bloc/project.dart';

class SetupParticipationPage extends StatelessWidget {
  final Project project;

  const SetupParticipationPage({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController dailyDonationController = TextEditingController();
    final TextEditingController householdSizeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Participation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              project.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: dailyDonationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Daily Donation Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: householdSizeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Household Size',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final dailyDonation = double.tryParse(dailyDonationController.text);
                        final householdSize = int.tryParse(householdSizeController.text);

                        if (dailyDonation != null && householdSize != null) {
                          // Logic to save the participation details
                          print('Daily Donation: $dailyDonation, Household Size: $householdSize');
                          Navigator.pop(context); // Navigate back after setup
                        } else {
                          // Show error if inputs are invalid
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Invalid Input'),
                              content: const Text('Please enter valid numbers for both fields.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}