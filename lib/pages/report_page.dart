// lib/pages/report_page.dart
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  final String subCategoryName;
  final List<dynamic> questions;
  final Map<int, String> answers;
  final VoidCallback onRestart;

  const ReportPage({
    required this.subCategoryName,
    required this.questions,
    required this.answers,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$subCategoryName - Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final q = questions[index];
            final answer = answers[q['id']] ?? 'No answer';
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(q['question'] ?? ''),
                subtitle: Text(answer),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: onRestart,
          child: const Text('Restart'),
        ),
      ),
    );
  }
}
