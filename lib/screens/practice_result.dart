import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  String _scoreMessage = "Tap Listen first, then record the child repeating it.";

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
      return [];
    }

    return widget.difficultWords
        .split(",")
        .map((w) => w.trim().toLowerCase())
        .where((w) => w.isNotEmpty)
        .toSet()
        .toList();
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
    if (typedWords.isEmpty) {
      return _fallbackWords();
    }

    if (widget.targetSound == "R") {
      final rWords = typedWords.where((w) => w.contains("r")).toList();
      return rWords.isEmpty ? _fallbackWords() : rWords;
    }

    if (widget.targetSound == "S") {
      final sWords = typedWords.where((w) => w.contains("s")).toList();
      return sWords.isEmpty ? _fallbackWords() : sWords;
    }

    return typedWords;
  }

  String _genreScene() {
    switch (widget.preference) {
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
    switch (widget.preference) {
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
    switch (widget.preference) {
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
    buffer.writeln(
      "In ${_genreScene()}, ${widget.name} practiced the ${widget.targetSound} sound.",
    );
    buffer.writeln(_storyOpener());
    buffer.writeln();

    for (final word in words) {
      buffer.writeln("The word \"$word\" ${_genreAction()}.");
      buffer.writeln("${widget.name} practiced: ${_repeatWord(word, 3)}.");
      buffer.writeln(
        "Sentence practice: \"$word\" is strong, \"$word\" is clear, \"$word\" sounds great.",
      );
      buffer.writeln();
    }

    buffer.writeln(
      "Goal: practice ${widget.targetSound} in the ${widget.position} position using ${words.join(", ")}.",
    );
    return buffer.toString();
  }

  String generateSong(List<String> words) {
    final buffer = StringBuffer();
    buffer.writeln("Song Time");
    buffer.writeln();
    buffer.writeln("Genre beat: ${widget.preference}");
    buffer.writeln();

    for (final word in words) {
      buffer.writeln("${_repeatWord(word, 2)}, sing it slow,");
      buffer.writeln("${_repeatWord(word, 2)}, clear and bright,");
      buffer.writeln(
        "$word, $word, $word, say the ${widget.targetSound} sound just right.",
      );
      buffer.writeln();
    }

    buffer.writeln("${widget.name} keeps practicing every day.");
    return buffer.toString();
  }

  String generateContent() {
    final words = _focusWords();
    if (words.isEmpty) return "No practice words available.";

    if (widget.practiceType == "Story") return generateStory(words);
    if (widget.practiceType == "Song") return generateSong(words);
    return "${generateStory(words)}\n\n${generateSong(words)}";
  }

  Future<void> _playContent() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }

    final content = generateContent();
    await _tts.stop();
    await _tts.speak(content);
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
      setState(() {
        _scoreMessage = "Microphone unavailable. Check app permission.";
      });
      return;
    }

    setState(() {
      _recognizedText = "";
      _score = 0;
      _isListening = true;
      _scoreMessage = "Listening... child should repeat what was heard.";
    });

    _speech.listen(
      onResult: (result) {
        if (!mounted) return;
        setState(() {
          _recognizedText = result.recognizedWords.toLowerCase();
        });
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

  void _calculateScore() {
    final expected = _focusWords();
    if (expected.isEmpty || _recognizedText.trim().isEmpty) {
      setState(() {
        _score = 0;
        _scoreMessage = "No speech detected yet. Try recording again.";
      });
      return;
    }

    int matched = 0;
    for (final word in expected) {
      if (_recognizedText.contains(word)) {
        matched++;
      }
    }

    final percent = ((matched / expected.length) * 100).round();
    setState(() {
      _score = percent;
      if (percent >= 85) {
        _scoreMessage = "Excellent pronunciation and repetition.";
      } else if (percent >= 60) {
        _scoreMessage = "Good attempt. Repeat once more for a higher score.";
      } else {
        _scoreMessage = "Keep practicing. Listen again and repeat slowly.";
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
        title: const Text("Practice Time"),
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
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Target sound: ${widget.targetSound}"),
                      Text("Position: ${widget.position}"),
                      Text("Genre: ${widget.preference}"),
                      Text("Practice type: ${widget.practiceType}"),
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
                      Text(
                        "Detected difficult words with R: ${rWords.isEmpty ? "none" : rWords.join(", ")}",
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Detected difficult words with S: ${sWords.isEmpty ? "none" : sWords.join(", ")}",
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Words used for this practice (${widget.targetSound.toUpperCase()} focus): ${focused.join(", ")}",
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
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                      const SizedBox(height: 6),
                      Text(
                        "Recorded speech: ${_recognizedText.isEmpty ? "No recording yet." : _recognizedText}",
                      ),
                    ],
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
