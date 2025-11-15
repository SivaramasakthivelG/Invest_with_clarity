import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/question_provider.dart';
import '../providers/auth_provider.dart';
import 'report_page.dart';

class QuestionPage extends StatefulWidget {
  final int subCategoryId;
  const QuestionPage({required this.subCategoryId});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final _answerController = TextEditingController();
  String subCategoryName = '';

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    Future.microtask(() {
      Provider.of<QuestionProvider>(context, listen: false)
          .fetchQuestions(auth.token.toString(), widget.subCategoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final qp = Provider.of<QuestionProvider>(context);


    if (qp.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (qp.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(subCategoryName)),
        body: Center(child: Text(qp.errorMessage!)),
      );
    }

    if (qp.isFinished) {
      return ReportPage(
        subCategoryName: subCategoryName,
        answers: qp.answers,
        questions: qp.questions,
        onRestart: qp.restart,
      );
    }

    final current = qp.questions[qp.currentIndex];

    _answerController.text = qp.answers[current['id']] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(subCategoryName)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${qp.currentIndex + 1}/${qp.questions.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              current['questionText'] ?? 'No question text',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: 'Your answer',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  qp.saveAnswer(current['id'], value),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    qp.saveAnswer(current['id'], _answerController.text);
                    qp.nextQuestion();

                  },
                  child: Text(
                    qp.currentIndex == qp.questions.length - 1
                        ? 'Finish'
                        : 'Next',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
