import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'parent_details.dart';
import '../services/parent_pin_service.dart';

class PracticeResultScreen extends StatefulWidget {
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

  @override
  State<PracticeResultScreen> createState() => _PracticeResultScreenState();
}

class _PracticeResultScreenState extends State<PracticeResultScreen> {
  late final FlutterTts _tts;
  late final stt.SpeechToText _speech;

  bool _isSpeaking = false;
  bool _isListening = false;
  String _recognizedText = "";
  int _score = 0;
  String _scoreMessage = "Tap Listen, then record and repeat.";

  static final RegExp _lettersOnly = RegExp("^[a-z]+\$");

  static const Set<String> _blockedWords = {
    "hacker",
    "stalker",
    "lover",
    "sex",
    "sexy",
    "kiss",
    "kissing",
    "romance",
    "violent",
    "violence",
    "kill",
    "killing",
    "dead",
    "murder",
    "gun",
    "weapon",
    "drugs",
    "alcohol",
    "beer",
    "adult",
    "nude",
  };

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

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _speech = stt.SpeechToText();
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

  List<String> _allDifficultWords() {
    if (widget.difficultWords.trim().isEmpty) {
      return _safeReplacementWords.take(4).toList();
    }

    final cleaned = widget.difficultWords
        .split(",")
        .map((w) => w.trim().toLowerCase())
        .where((w) => w.isNotEmpty && _lettersOnly.hasMatch(w))
        .where((w) => !_blockedWords.contains(w))
        .toSet()
        .toList();

    if (cleaned.isNotEmpty) {
      return cleaned.take(6).toList();
    }

    return _safeReplacementWords.take(4).toList();
  }

  List<String> _detectedRWords() {
    return _allDifficultWords().where((w) => w.contains("r")).toList();
  }

  List<String> _detectedSWords() {
    return _allDifficultWords().where((w) => w.contains("s")).toList();
  }

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

    return ["practice"];
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

    return typedWords.take(4).toList();
  }

  String _genreScene() {
    switch (widget.preference) {
      case "Comedy":
        return "a funny town full of giggles";
      case "Fantasy":
        return "a magical kingdom with friendly dragons";
      case "Friendship":
        return "a happy village where friends help each other";
      case "Adventure":
        return "a bright trail with clues and treasure maps";
      case "Mystery":
        return "a curious town with playful puzzles";
      case "Science Fiction":
        return "a future city with kind robots";
      case "Superhero":
        return "a hero city where everyone works as a team";
      case "Fairy Tale":
        return "an enchanted forest with talking animals";
      case "Animals":
        return "a cheerful animal park";
      case "Sports":
        return "a stadium full of cheering teammates";
      default:
        return "a colorful story world";
    }
  }

  String _repeatWord(String word, int count) {
    return List.generate(count, (_) => word).join(", ");
  }

  String _rhymeLineA(String word) {
    return "$word, $word, clap and play,";
  }

  String _rhymeLineB(String word) {
    return "$word, $word, bright today,";
  }

  String _rhymeLineC(String word) {
    return "$word, $word, say hooray,";
  }

  String generateStory(List<String> words) {
    final buffer = StringBuffer();
    buffer.writeln("Story Time");
    buffer.writeln();
    buffer.writeln(
      "In ${_genreScene()}, ${widget.name} practiced the ${widget.targetSound} sound.",
    );
    buffer.writeln();

    for (final word in words) {
      buffer.writeln("Practice word: $word");
      buffer.writeln("${widget.name} says: ${_repeatWord(word, 3)}.");
      buffer.writeln("Great speaking. Keep going.");
      buffer.writeln();
    }

    buffer.writeln("Goal: practice ${widget.targetSound} in ${widget.position} words.");
    return buffer.toString();
  }

  String generateSong(List<String> words) {
    final buffer = StringBuffer();
    buffer.writeln("Rhyme Song Time");
    buffer.writeln();
    buffer.writeln("Sing with a smile and gentle voice.");
    buffer.writeln();
    for (final word in words) {
      buffer.writeln(_rhymeLineA(word));
      buffer.writeln(_rhymeLineB(word));
      buffer.writeln(_rhymeLineC(word));
      buffer.writeln(
        "Say the ${widget.targetSound} sound clearly today.",
      );
      buffer.writeln("$word, $word, hip hip hooray.");
      buffer.writeln();
    }
    buffer.writeln("${widget.name} sings and practices every day.");
    return buffer.toString();
  }

  String generateContent() {
    final words = _focusWords();
    if (widget.practiceType == "Story") return generateStory(words);
    if (widget.practiceType == "Song") return generateSong(words);
    return "${generateStory(words)}\n\n${generateSong(words)}";
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
      builder: (context) {
        return AlertDialog(
          title: const Text("Parent Access"),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Enter PIN"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, pinController.text.trim()),
              child: const Text("Open"),
            ),
          ],
        );
      },
    );

    if (!mounted || enteredPin == null) return;

    final savedPin = await ParentPinService.getPin();
    if (enteredPin != savedPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect PIN")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParentDetailsScreen(
          score: _score,
          scoreMessage: _scoreMessage,
          speechPreview: _recognizedText,
          practiceWords: _focusWords(),
          targetSound: widget.targetSound,
          position: widget.position,
        ),
      ),
    );
  }

  void _calculateScore() {
    final expected = _focusWords();
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
    setState(() {
      _score = percent;
      if (percent >= 85) {
        _scoreMessage = "Amazing job. Very clear speaking.";
      } else if (percent >= 60) {
        _scoreMessage = "Nice try. One more round for extra stars.";
      } else {
        _scoreMessage = "Good effort. Listen again and say each word slowly.";
      }
    });
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
        title: GestureDetector(
          onLongPress: _openParentDetails,
          child: const Text("Practice Time"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Great job, ${widget.name}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Target: ${widget.targetSound}  |  Position: ${widget.position}\n"
                    "R words: ${rWords.isEmpty ? "none" : rWords.join(", ")}\n"
                    "S words: ${sWords.isEmpty ? "none" : sWords.join(", ")}\n"
                    "Practice words: ${focused.join(", ")}",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    generateContent(),
                    style: const TextStyle(fontSize: 18, height: 1.45),
                  ),
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
              const SizedBox(height: 16),
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
