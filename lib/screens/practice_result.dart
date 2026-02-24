import 'package:flutter/material.dart';

class PracticeResultScreen extends StatelessWidget {
  final String name;
  final String preference;
  final String practiceType;
  final String difficultWords;
  final String targetSound;
  final String position;

  const PracticeResultScreen({
    super.key,
    required this.name,
    required this.preference,
    required this.practiceType,
    required this.difficultWords,
    required this.targetSound,
    required this.position,
  });

  // Step 1: Get word list (custom OR fallback)
  List<String> generateWordList() {
    if (difficultWords.isNotEmpty) {
      return difficultWords
          .split(",")
          .map((w) => w.trim().toLowerCase())
          .where((w) => w.isNotEmpty)
          .toList();
    }

    if (targetSound == "S") {
      if (position == "Beginning") {
        return ["sun", "snake", "sister"];
      } else if (position == "Middle") {
        return ["messy", "pencil", "outside"];
      } else {
        return ["bus", "glass", "dress"];
      }
    }

    if (targetSound == "R") {
      if (position == "Beginning") {
        return ["rabbit", "rain", "rocket"];
      } else if (position == "Middle") {
        return ["carrot", "parrot", "forest"];
      } else {
        return ["car", "star", "bear"];
      }
    }

    return ["practice"];
  }

  // Step 2: Generate Story
  String generateStory(List<String> words) {
    String story = "📖 Once upon a time in a $preference world,\n\n";

    for (var word in words) {
      story += "The $word was very special. ";
      story += "The $word loved to shine brightly. ";
      story += "Everyone said $word, $word, $word again and again. ";
      story += "\n\n";
    }

    story +=
        "This story helps practice the $targetSound sound in the $position position. ✨";

    return story;
  }

  // Step 3: Generate Song
  String generateSong(List<String> words) {
    String song = "🎵 Sing along!\n\n";

    for (var word in words) {
      song += "$word, $word, say it slow,\n";
      song += "$word, $word, let it flow!\n";
      song += "Say $word loud, say $word clear,\n";
      song += "Practice $word so we can hear!\n\n";
    }

    song += "Practice the $targetSound sound every day! 🎶";

    return song;
  }

  // Step 4: Decide what to show
  String generateContent() {
    List<String> words = generateWordList();

    if (words.isEmpty) {
      return "No practice words provided.";
    }

    if (practiceType == "Story") {
      return generateStory(words);
    }

    if (practiceType == "Song") {
      return generateSong(words);
    }

    return generateStory(words) + "\n\n" + generateSong(words);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("🌟 Practice Time!"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                "Great Job, $name! 🎉",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Info Card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("🎯 Target Sound: $targetSound"),
                      Text("📍 Position: $position"),
                      Text("🌈 Theme: $preference"),
                      Text("🎭 Practice Type: $practiceType"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Generated Practice
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Text(
                    generateContent(),
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "🔁 Practice Again",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}