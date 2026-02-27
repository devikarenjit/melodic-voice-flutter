import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'parent_details.dart';
import '../services/parent_pin_service.dart';

class PracticeResultScreen extends StatefulWidget {
  final String name;
  final int age;
  final String preference;
  final String practiceType;
  final String targetSound;
  final String position;

  const PracticeResultScreen({
    super.key,
    required this.name,
    required this.age,
    required this.preference,
    required this.practiceType,
    required this.targetSound,
    required this.position,
  });

  @override
  State<PracticeResultScreen> createState() => _PracticeResultScreenState();
}

class _PracticeResultScreenState extends State<PracticeResultScreen> {
  late final FlutterTts _tts;
  late final stt.SpeechToText _speech;
  late final _StoryTemplate _storyTemplate;

  bool _isSpeaking = false;
  bool _isListening = false;
  bool _hasAttemptedRetell = false;
  String _recognizedText = "";
  int _score = 0;
  String _scoreMessage = "Tap Listen, then record and retell.";
  List<String> _practiceWords = [];

  static const List<String> _safeReplacementWords = [
    "rabbit",
    "sun",
    "star",
    "rose",
    "story",
    "smile",
    "rainbow",
    "sister",
  ];

  int get _age {
    if (widget.age < 3) return 3;
    if (widget.age > 12) return 12;
    return widget.age;
  }

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _speech = stt.SpeechToText();
    _storyTemplate = _storyTemplateByAgeAndGenre();
    _setupTts();
  }

  @override
  void dispose() {
    _tts.stop();
    _speech.stop();
    super.dispose();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.0);
    _tts.setStartHandler(() {
      if (!mounted) return;
      setState(() => _isSpeaking = true);
    });
    _tts.setCompletionHandler(() {
      if (!mounted) return;
      setState(() => _isSpeaking = false);
    });
    _tts.setCancelHandler(() {
      if (!mounted) return;
      setState(() => _isSpeaking = false);
    });
  }

  List<String> _allDifficultWords() => _safeReplacementWords.take(6).toList();

  List<String> _detectedRWords() => _allDifficultWords().where((w) => w.contains("r")).toList();
  List<String> _detectedSWords() => _allDifficultWords().where((w) => w.contains("s")).toList();

  List<String> _fallbackWords() {
    if (widget.targetSound == "S") {
      if (widget.position == "Beginning") return ["sun", "snake", "sister"];
      if (widget.position == "Middle") return ["pencil", "outside", "messy"];
      return ["bus", "glass", "dress"];
    }
    if (widget.targetSound == "R") {
      if (widget.position == "Beginning") return ["rabbit", "rain", "rocket"];
      if (widget.position == "Middle") return ["carrot", "parrot", "forest"];
      return ["car", "star", "bear"];
    }
    return ["sun", "snake", "sister"];
  }

  List<String> _focusWords() {
    final typedWords = _allDifficultWords();
    if (typedWords.isEmpty) return _fallbackWords();
    if (widget.targetSound == "R") {
      final rWords = typedWords.where((w) => w.contains("r")).toList();
      return rWords.isEmpty ? _fallbackWords() : rWords.take(4).toList();
    }
    if (widget.targetSound == "S") {
      final sWords = typedWords.where((w) => w.contains("s")).toList();
      return sWords.isEmpty ? _fallbackWords() : sWords.take(4).toList();
    }
    return _fallbackWords();
  }

  List<String> _ageAdjustedWords(List<String> words) {
    if (words.isEmpty) return words;
    if (_age <= 4) {
      final shortWords = words.where((w) => w.length <= 4).toList();
      return (shortWords.isEmpty ? ["sun", "star"] : shortWords).take(2).toList();
    }
    if (_age <= 7) {
      final mediumShort = words.where((w) => w.length <= 5).toList();
      return (mediumShort.isEmpty ? words : mediumShort).take(3).toList();
    }
    if (_age <= 10) {
      final medium = words.where((w) => w.length <= 7).toList();
      return (medium.isEmpty ? words : medium).take(4).toList();
    }
    final longer = words.where((w) => w.length <= 10).toList();
    return (longer.isEmpty ? words : longer).take(5).toList();
  }

  String _targetSoundLabel() => widget.targetSound;

  String _targetSoundWordLine() {
    if (widget.targetSound == "R") {
      final rWords = _detectedRWords();
      return "R words: ${rWords.isEmpty ? "none" : rWords.join(", ")}";
    }
    if (widget.targetSound == "S") {
      final sWords = _detectedSWords();
      return "S words: ${sWords.isEmpty ? "none" : sWords.join(", ")}";
    }
    return "Target words: none";
  }

  _StoryTemplate _storyTemplateByAgeAndGenre() {
    if (_age <= 5) {
      switch (widget.preference) {
        case "Animals":
          return const _StoryTemplate(
            title: "At The Animal Park",
            emoji: "🐾",
            lines: [
              "Mia visits the animal park with her class.",
              "She sees a rabbit, a goat, and a small bird.",
              "The children smile, clap, and feed the animals.",
              "Everyone waves goodbye before going home.",
            ],
          );
        case "Sports":
          return const _StoryTemplate(
            title: "Playground Race",
            emoji: "🏃",
            lines: [
              "Sam and Ria run a short race.",
              "They cheer for each other with big smiles.",
              "Teacher gives both children a star sticker.",
              "They drink water and play again.",
            ],
          );
        default:
          return const _StoryTemplate(
            title: "My School Day",
            emoji: "🏫",
            lines: [
              "Asha goes to school with her red bag.",
              "She reads, draws, and sings with friends.",
              "The class shares snacks and circle games.",
              "Everyone says bye at home time.",
            ],
          );
      }
    }

    if (_age <= 8) {
      switch (widget.preference) {
        case "Adventure":
          return const _StoryTemplate(
            title: "School Treasure Hunt",
            emoji: "🗺️",
            lines: [
              "The class starts a treasure hunt in school.",
              "Arun and Sara follow clues near the library.",
              "They find a hidden box with story cards.",
              "Each friend reads one card aloud.",
              "The teacher praises their teamwork.",
            ],
          );
        case "Fantasy":
        case "Fairy Tale":
          return const _StoryTemplate(
            title: "The Talking Pencil",
            emoji: "✨",
            lines: [
              "Nina finds a shiny pencil in her desk.",
              "The pencil gives gentle reading tips.",
              "Nina uses the tips to read clearly.",
              "She shares the tips with her friends.",
              "The class cheers for her progress.",
            ],
          );
        default:
          return const _StoryTemplate(
            title: "Library Helpers",
            emoji: "📚",
            lines: [
              "Four friends help arrange books in the library.",
              "They sort story books and science books.",
              "Each friend reads a page with clear voice.",
              "The librarian thanks them for helping.",
              "They borrow books to practice at home.",
            ],
          );
      }
    }

    switch (widget.preference) {
      case "Science Fiction":
        return const _StoryTemplate(
          title: "The Class Space Project",
          emoji: "🚀",
          lines: [
            "Grade six begins a science space project.",
            "Rohan builds a model rocket with recycled parts.",
            "Sana reads launch steps to the team.",
            "They test the model and improve each trial.",
            "On project day, they present clearly.",
            "The teacher praises their speaking confidence.",
          ],
        );
      case "Mystery":
        return const _StoryTemplate(
          title: "The Missing Notebook",
          emoji: "🕵️",
          lines: [
            "Before class, a notebook goes missing.",
            "Leela checks the classroom and hallway.",
            "Her friends follow clues from a name label.",
            "They find the notebook in the reading corner.",
            "Leela explains each clue to the class.",
            "Everyone learns calm problem solving.",
          ],
        );
      default:
        return const _StoryTemplate(
          title: "School Garden Project",
          emoji: "🌱",
          lines: [
            "The class begins a school garden project.",
            "Teams prepare soil and plant seeds.",
            "Students read instructions and repeat key words.",
            "After weeks, the garden blooms with flowers.",
            "The class presents results to parents.",
            "They celebrate teamwork and clear speaking.",
          ],
        );
    }
  }

  int _storyLineCountByAge() {
    if (_age <= 4) return 2;
    if (_age <= 6) return 3;
    if (_age <= 8) return 4;
    if (_age <= 10) return 5;
    return 6;
  }

  int _repeatCountByAge() => _age <= 8 ? 3 : 2;

  String _repeatWord(String word, int count) => List.generate(count, (_) => word).join(", ");

  String generateStory() {
    final lines = _storyTemplate.lines.take(_storyLineCountByAge()).toList();
    final buffer = StringBuffer()
      ..writeln(_storyTemplate.title)
      ..writeln();
    for (final line in lines) {
      buffer.writeln(line);
    }
    return buffer.toString();
  }

  String generateSong() {
    final buffer = StringBuffer()
      ..writeln("Story Song")
      ..writeln()
      ..writeln("Sing the story of ${_storyTemplate.title}.")
      ..writeln("Listen carefully, then retell in your own voice.")
      ..writeln("Speak the ${_targetSoundLabel()} sound clearly.");
    return buffer.toString();
  }

  String _practiceRepeatSection() {
    if (_practiceWords.isEmpty) return "";
    final buffer = StringBuffer()
      ..writeln("Practice Repeat")
      ..writeln();
    for (final word in _practiceWords) {
      buffer.writeln(_repeatWord(word, _repeatCountByAge() + 1));
      buffer.writeln();
    }
    return buffer.toString();
  }

  String generateContent() {
    final repeat = _hasAttemptedRetell ? _practiceRepeatSection() : "";
    if (widget.practiceType == "Story") return repeat.isEmpty ? generateStory() : "${generateStory()}\n\n$repeat";
    if (widget.practiceType == "Song") return repeat.isEmpty ? generateSong() : "${generateSong()}\n\n$repeat";
    final base = "${generateStory()}\n\n${generateSong()}";
    return repeat.isEmpty ? base : "$base\n\n$repeat";
  }

  Future<void> _playContent() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
    await _tts.stop();
    await _tts.speak(generateContent());
  }

  Future<void> _startRecording() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        if (status == "done" || status == "notListening") {
          setState(() => _isListening = false);
          _calculateScore();
        }
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _isListening = false;
          _scoreMessage = "Recording error: ${error.errorMsg}";
        });
      },
    );

    if (!available) {
      setState(() => _scoreMessage = "Microphone unavailable. Check permission.");
      return;
    }

    setState(() {
      _recognizedText = "";
      _score = 0;
      _isListening = true;
      _scoreMessage = "Listening...";
    });

    _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() => _recognizedText = result.recognizedWords.toLowerCase());
      },
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(minutes: 5),
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
    );
  }

  Future<void> _stopRecording() async {
    await _speech.stop();
    if (!mounted) return;
    setState(() => _isListening = false);
    _calculateScore();
  }

  Future<void> _openParentDetails() async {
    final pinController = TextEditingController();
    final enteredPin = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Parent Access"),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Enter PIN"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, pinController.text.trim()),
            child: const Text("Open"),
          ),
        ],
      ),
    );

    if (!mounted || enteredPin == null) return;
    final savedPin = await ParentPinService.getPin();
    if (enteredPin != savedPin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect PIN")));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParentDetailsScreen(
          score: _score,
          scoreMessage: _scoreMessage,
          speechPreview: _recognizedText,
          practiceWords: _practiceWords,
          targetSound: widget.targetSound,
          position: widget.position,
        ),
      ),
    );
  }

  void _calculateScore() {
    final expected = _filterByTargetSound(_extractStoryKeywords()).take(8).toList();
    if (expected.isEmpty || _recognizedText.trim().isEmpty) {
      setState(() {
        _score = 0;
        _scoreMessage = "No speech detected. Try again.";
      });
      return;
    }

    var matched = 0;
    for (final word in expected) {
      if (_recognizedText.contains(word)) matched++;
    }

    final percent = ((matched / expected.length) * 100).round();
    final recognizedWords =
        RegExp(r"[a-z]+").allMatches(_recognizedText).map((m) => m.group(0)!).toSet();
    var missed = expected.where((w) => !recognizedWords.contains(w)).toList();
    if (missed.isEmpty) {
      missed = _filterByTargetSound(_ageAdjustedWords(_focusWords()));
    }

    setState(() {
      _score = percent;
      _hasAttemptedRetell = true;
      _practiceWords = _ageAdjustedWords(missed.take(5).toList());
      if (percent >= 85) {
        _scoreMessage = "Amazing job. Very clear speaking.";
      } else if (percent >= 60) {
        _scoreMessage = "Nice try. One more round for extra stars.";
      } else {
        _scoreMessage = "Good effort. Listen again and say each word slowly.";
      }
    });
  }

  List<String> _extractStoryKeywords() {
    final joined = _storyTemplate.lines.take(_storyLineCountByAge()).join(" ").toLowerCase();
    const stopWords = {
      "the",
      "and",
      "with",
      "they",
      "them",
      "then",
      "into",
      "from",
      "that",
      "this",
      "were",
      "was",
      "while",
      "when",
      "their",
      "after",
      "again",
      "very",
      "over",
      "through",
      "there",
      "where",
      "have",
      "has",
      "had",
      "for",
      "her",
      "his",
      "she",
      "him",
      "our",
      "your",
      "one",
      "two",
      "day",
    };

    return RegExp(r"[a-z]+")
        .allMatches(joined)
        .map((m) => m.group(0)!)
        .where((w) => w.length >= 4 && !stopWords.contains(w))
        .toSet()
        .toList();
  }

  List<String> _filterByTargetSound(List<String> words) {
    if (widget.targetSound == "R") return words.where((w) => w.contains("r")).toList();
    if (widget.targetSound == "S") return words.where((w) => w.contains("s")).toList();
    return [];
  }

  String _wordPicture(String word) {
    const pictureMap = {
      "sun": "☀️",
      "star": "⭐",
      "rain": "🌧️",
      "rabbit": "🐰",
      "rose": "🌹",
      "snake": "🐍",
      "sister": "👧",
      "car": "🚗",
      "forest": "🌲",
      "flower": "🌸",
      "house": "🏠",
      "ball": "⚽",
      "ship": "🚢",
      "bell": "🔔",
      "mouse": "🐭",
      "goat": "🐐",
      "garden": "🌱",
      "class": "🏫",
      "rocket": "🚀",
      "project": "🧪",
      "notebook": "📓",
      "library": "📚",
    };
    return pictureMap[word] ?? "🖼️";
  }

  @override
  Widget build(BuildContext context) {
    final focused = _practiceWords;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: GestureDetector(onLongPress: _openParentDetails, child: const Text("Practice Time")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Great job, ${widget.name}",
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(_storyTemplate.emoji, style: const TextStyle(fontSize: 56)),
                      const SizedBox(height: 6),
                      Text(_storyTemplate.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Target: ${widget.targetSound}  |  Position: ${widget.position}\n"
                    "${_targetSoundWordLine()}\n"
                    "Practice words appear after retell.",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(generateContent(), style: const TextStyle(fontSize: 18, height: 1.45)),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isSpeaking ? null : _playContent,
                    icon: const Icon(Icons.volume_up),
                    label: Text(_isSpeaking ? "Playing..." : "Listen"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isListening ? null : _startRecording,
                    icon: const Icon(Icons.mic),
                    label: const Text("Start Recording"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isListening ? _stopRecording : null,
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                color: const Color(0xFFF8F2FF),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Score: $_score / 100"),
                      const SizedBox(height: 6),
                      Text(_scoreMessage),
                    ],
                  ),
                ),
              ),
              if (_hasAttemptedRetell) ...[
                const SizedBox(height: 12),
                const Text("Words To Practice", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: focused.map((word) {
                    return Card(
                      color: const Color(0xFFEDE7FF),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(word, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Practice Again")),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryTemplate {
  final String title;
  final String emoji;
  final List<String> lines;

  const _StoryTemplate({
    required this.title,
    required this.emoji,
    required this.lines,
  });
}
