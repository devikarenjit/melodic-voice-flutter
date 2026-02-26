import 'package:flutter/material.dart';

class ParentDetailsScreen extends StatelessWidget {
  final int score;
  final String scoreMessage;
  final String speechPreview;
  final List<String> practiceWords;
  final String targetSound;
  final String position;

  const ParentDetailsScreen({
    super.key,
    required this.score,
    required this.scoreMessage,
    required this.speechPreview,
    required this.practiceWords,
    required this.targetSound,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Parent Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Score: $score / 100"),
                    const SizedBox(height: 8),
                    Text(scoreMessage),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Target sound: $targetSound"),
                    Text("Position: $position"),
                    const SizedBox(height: 8),
                    Text("Practice words: ${practiceWords.join(", ")}"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Speech Preview",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      speechPreview.isEmpty ? "No recording yet." : speechPreview,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
