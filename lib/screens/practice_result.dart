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

  List<String> _allDifficultWords() {
    if (difficultWords.trim().isEmpty) {
      return [];
    }

    final words = difficultWords
        .split(",")
        .map((w) => w.trim().toLowerCase())
        .where((w) => w.isNotEmpty)
        .toSet()
        .toList();
    return words;
  }

  List<String> _detectedRWords() {
    return _allDifficultWords().where((w) => w.contains("r")).toList();
  }

  List<String> _detectedSWords() {
    return _allDifficultWords().where((w) => w.contains("s")).toList();
  }

  List<String> _fallbackWords() {
    if (targetSound == "S") {
      if (position == "Beginning") {
        return ["sun", "snake", "sister"];
      }
      if (position == "Middle") {
        return ["pencil", "outside", "messy"];
      }
      return ["bus", "glass", "dress"];
    }

    if (targetSound == "R") {
      if (position == "Beginning") {
        return ["rabbit", "rain", "rocket"];
      }
      if (position == "Middle") {
        return ["carrot", "parrot", "forest"];
      }
      return ["car", "star", "bear"];
    }

    return ["practice"];
  }

  List<String> _focusWords() {
    final typedWords = _allDifficultWords();
    if (typedWords.isEmpty) {
      return _fallbackWords();
    }

    if (targetSound == "R") {
      final rWords = typedWords.where((w) => w.contains("r")).toList();
      return rWords.isEmpty ? _fallbackWords() : rWords;
    }

    if (targetSound == "S") {
      final sWords = typedWords.where((w) => w.contains("s")).toList();
      return sWords.isEmpty ? _fallbackWords() : sWords;
    }

    return typedWords;
  }

  String _genreScene() {
    switch (preference) {
      case "Comedy":
        return "a funny town full of giggles";
      case "Fantasy":
        return "a magical kingdom of dragons and castles";
      case "Romance":
        return "a warm village where everyone shares kindness";
      case "Adventure":
        return "a wild trail with maps and hidden treasure";
      case "Mystery":
        return "a curious city full of clues";
      case "Science Fiction":
        return "a future world with robots and starships";
      case "Superhero":
        return "a hero city that needs brave helpers";
      case "Fairy Tale":
        return "an enchanted forest with talking animals";
      case "Animals":
        return "a friendly animal park";
      case "Sports":
        return "a busy stadium on game day";
      default:
        return "a bright story world";
    }
  }

  String _genreAction() {
    switch (preference) {
      case "Comedy":
        return "made everyone laugh";
      case "Fantasy":
        return "sparkled with magic";
      case "Romance":
        return "shared sweet words";
      case "Adventure":
        return "helped solve the quest";
      case "Mystery":
        return "unlocked a new clue";
      case "Science Fiction":
        return "powered the mission";
      case "Superhero":
        return "saved the day";
      case "Fairy Tale":
        return "brought wonder";
      case "Animals":
        return "made the animals cheer";
      case "Sports":
        return "won the crowd";
      default:
        return "sounded great";
    }
  }

  String _repeatWord(String word, int count) {
    return List.generate(count, (_) => word).join(", ");
  }

  String _storyOpener() {
    switch (preference) {
      case "Comedy":
        return "One bright morning, a silly surprise made everyone laugh.";
      case "Fantasy":
        return "At sunrise, a magical wind moved through the kingdom.";
      case "Romance":
        return "On a calm day, kind hearts gathered in the town square.";
      case "Adventure":
        return "At dawn, the map glowed and the journey began.";
      case "Mystery":
        return "At first light, a new clue appeared near the old gate.";
      case "Science Fiction":
        return "At launch time, the crew prepared for a star mission.";
      case "Superhero":
        return "At sunrise, the city called for a brave helper.";
      case "Fairy Tale":
        return "At morning bell, the enchanted forest woke up.";
      case "Animals":
        return "At feeding time, every animal was excited.";
      case "Sports":
        return "Before the big game, the crowd started to cheer.";
      default:
        return "A new day started in a bright story world.";
    }
  }

  String generateStory(List<String> words) {
    final buffer = StringBuffer();
    buffer.writeln("Story Time");
    buffer.writeln();
    buffer.writeln("In ${_genreScene()}, $name practiced the $targetSound sound.");
    buffer.writeln(_storyOpener());
    buffer.writeln();

    for (final word in words) {
      buffer.writeln("The word \"$word\" ${_genreAction()}.");
      buffer.writeln(
        "$name practiced: ${_repeatWord(word, 3)}.",
      );
      buffer.writeln(
        "Sentence practice: \"$word\" is strong, \"$word\" is clear, \"$word\" sounds great.",
      );
      buffer.writeln();
    }

    buffer.writeln(
      "Goal: practice $targetSound in the $position position using ${words.join(", ")}.",
    );
    return buffer.toString();
  }

  String generateSong(List<String> words) {
    final buffer = StringBuffer();
    buffer.writeln("Song Time");
    buffer.writeln();
    buffer.writeln("Genre beat: $preference");
    buffer.writeln();

    for (final word in words) {
      buffer.writeln("${_repeatWord(word, 2)}, sing it slow,");
      buffer.writeln("${_repeatWord(word, 2)}, clear and bright,");
      buffer.writeln("$word, $word, $word, say the $targetSound sound just right.");
      buffer.writeln();
    }

    buffer.writeln("$name keeps practicing every day.");
    return buffer.toString();
  }

  String generateContent() {
    final words = _focusWords();
    if (words.isEmpty) {
      return "No practice words available.";
    }

    if (practiceType == "Story") {
      return generateStory(words);
    }
    if (practiceType == "Song") {
      return generateSong(words);
    }
    return "${generateStory(words)}\n\n${generateSong(words)}";
  }

  @override
  Widget build(BuildContext context) {
    final rWords = _detectedRWords();
    final sWords = _detectedSWords();
    final focused = _focusWords();

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text("Practice Time"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Great job, $name",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Target sound: $targetSound"),
                      Text("Position: $position"),
                      Text("Genre: $preference"),
                      Text("Practice type: $practiceType"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Detected difficult words with R: ${rWords.join(", ")}"),
                      const SizedBox(height: 6),
                      Text("Detected difficult words with S: ${sWords.join(", ")}"),
                      const SizedBox(height: 6),
                      Text(
                        "Words used for this practice (${targetSound.toUpperCase()} focus): ${focused.join(", ")}",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    generateContent(),
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Practice Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
