import 'package:flutter/material.dart';

class ReferenceApplicationScreen extends StatelessWidget {
  final Function(int) onStepTapped;

  const ReferenceApplicationScreen({
    super.key,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reference Application Form',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'Application Process',
                      content:
                      'Our aim is to complete the referencing process as quickly as possible. To help things run smoothly, we will need you to provide us with some important information. Unfortunately, if we do not receive all of the information we require, this will cause delays or may negatively affect the outcome of your reference. Before completing the application process, we recommend you prepare by ensuring that you have all the necessary information and documents to hand.\n\nQuestions with a * next to them are mandatory. This means you must provide the information requested and it must be accurate.\n\nWhere you see the ℹ️ sign you can click the icon to learn more.',
                    ),
                    _buildSection(
                      title: 'Checklist of Required Documents',
                      content: '',
                      bulletPoints: [
                        'Your full addresses and postcodes for the last 3 years.',
                        'If you have rented, contact details of landlords/letting agents including email and phone number.',
                        'Proof of address (utility bill, phone bill, council tax document less than 3 months old).',
                        'Next of kin details (name and address of close family member).',
                        'Current income and employment details with employer/accountant contact information.',
                        'Access to your online banking for Open Banking verification.',
                        'Access to your payroll system (if required) for income verification.',
                        'Access to your Government Gateway for PAYE/benefits verification (if required).',
                        'Photo ID (valid passport or driving licence).',
                        'Right to Rent documentation (depending on your nationality).',
                      ],
                    ),
                    _buildSection(
                      title: 'Important Notes',
                      content: '',
                      bulletPoints: [
                        'We request references by email - ensure email addresses are correct.',
                        'Proof of address should be uploaded in PDF format.',
                        'We never request your login details for banking/payroll systems.',
                        'Photo ID should be uploaded as image files (PNG, BMP, JPEG), not PDF.',
                        'Foreign nationals may need to provide a Right to Rent Share Code.',
                      ],
                    ),
                    _buildSection(
                      title: 'Application Features',
                      content: '',
                      bulletPoints: [
                        'Save for Later: You can save your progress and return later.',
                        'Sign and Submit: Once submitted, you cannot change information and the link will expire.',
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'For more information including video guides click here: ',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle link tap
                      },
                      child: const Text(
                        'Referencing Guide',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Remember, always answer all of the questions honestly and accurately!',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => onStepTapped(1), // This now uses the passed function
                child: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<String>? bulletPoints,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        if (content.isNotEmpty)
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        if (bulletPoints != null && bulletPoints.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bulletPoints
                  .map(
                    (point) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .toList(),
            ),
          ),
      ],
    );
  }
}