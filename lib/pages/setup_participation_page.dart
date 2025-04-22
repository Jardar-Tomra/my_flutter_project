import 'package:flutter/material.dart';
import 'package:caritas_donation_app/bloc/project.dart';
import 'package:caritas_donation_app/bloc/user_bloc.dart';
import 'package:caritas_donation_app/styles/app_text_styles.dart';
import 'package:caritas_donation_app/styles/button_styles.dart';
import 'package:caritas_donation_app/widgets/single_select_chip_list.dart';

class SetupParticipationPage extends StatelessWidget {
  final Project project;

  const SetupParticipationPage({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    List<double> donationAmountsOptions = [5, 10, 15, 20, 30, 50];
    var houseHoldSizeOptions = List.generate(6, (index) => index + 1);
    double selectedDonationAmount = donationAmountsOptions[0]; // Default value
    int selectedHouseholdSize = 1;
    final List<String> participants = List.filled(6, ''); // Initialize with empty strings

    return StatefulBuilder(
      builder: (context, setState) {
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
                  height: 300,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
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
                      const Text(
                        'Select Daily Donation Amount:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SingleSelectChipList<double>(
                        items: donationAmountsOptions,
                        selectedItem: selectedDonationAmount,
                        onSelectionChanged: (value) {
                          setState(() {
                            selectedDonationAmount = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Household Size:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SingleSelectChipList<int>(
                        items: houseHoldSizeOptions,
                        selectedItem: selectedHouseholdSize,
                        onSelectionChanged: (value) {
                          setState(() {
                            selectedHouseholdSize = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Enter Participant Names:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: selectedHouseholdSize, // Adjust input fields dynamically
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Participant ${index + 1}',
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  participants[index] = value;
                                });
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Cancel and go back
                            },
                            style: ButtonStyles.secondaryButtonStyle,
                            child: const Text('Cancel', style: AppTextStyles.buttonTextStyle),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Ensure at least one participant name is provided
                              final validParticipants = participants
                                  .take(selectedHouseholdSize)
                                  .where((name) => name.trim().isNotEmpty)
                                  .toList();

                              if (validParticipants.isNotEmpty) {
                                context.activate(project.id, selectedDonationAmount, validParticipants);
                                // Confirm assignment
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Participation Confirmed'),
                                    content: const Text('You have been successfully assigned to this project.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ButtonStyles.primaryButtonStyle,
                                        child: const Text('OK', style: AppTextStyles.buttonTextStyle),
                                      ),
                                    ],
                                  ),
                                ).then((_) => Navigator.pop(context));
                              } else {
                                // Show error if inputs are invalid
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Invalid Input'),
                                    content: const Text('Please select a donation amount and enter at least one participant name.'),
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
                            style: ButtonStyles.primaryButtonStyle,
                            child: const Text('Confirm', style: AppTextStyles.buttonTextStyle),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

