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

  List<String> _detectedRWords() =>
      _allDifficultWords().where((w) => w.contains("r")).toList();
  List<String> _detectedSWords() =>
      _allDifficultWords().where((w) => w.contains("s")).toList();

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
      return (shortWords.isEmpty ? ["sun", "star"] : shortWords)
          .take(2)
          .toList();
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

  String _byAge({
    required String age3to5,
    required String age6to8,
    required String age9to12,
  }) {
    if (_age <= 5) return age3to5;
    if (_age <= 8) return age6to8;
    return age9to12;
  }

  _StoryTemplate _storyTemplateByAgeAndGenre() {
    switch (widget.preference) {
      case "Comedy":
        return _StoryTemplate(
          title: "The Silly Hat Day",
          emoji: "FUN",
          lines: [
            _byAge(
              age3to5:
                  "Mina wore a big hat. It bounced and made everyone giggle.",
              age6to8:
                  "Mina wore a wobbly hat to class, and each wobble made the room laugh.",
              age9to12:
                  "Mina's oversized hat kept tipping during assembly, and her playful jokes made everyone laugh.",
            ),
            _byAge(
              age3to5: "Ravi tried it too. The hat spun round and round.",
              age6to8:
                  "Ravi borrowed the hat, bowed like a comedian, and the class clapped and laughed.",
              age9to12:
                  "Ravi turned the hat into a mini comedy act with funny voices and timing that made the class burst out laughing.",
            ),
            _byAge(
              age3to5: "They laughed, smiled, and practiced clear words.",
              age6to8:
                  "After laughing, they slowed down and practiced their speech words clearly.",
              age9to12:
                  "After the laughter, they refocused and repeated target words with clear, confident pronunciation.",
            ),
          ],
        );
      case "Fantasy":
      case "Fairy Tale":
        return _StoryTemplate(
          title: "The Moonlight Door",
          emoji: "MAGIC",
          lines: [
            _byAge(
              age3to5:
                  "Sara found a tiny glowing door. It sparkled like stars.",
              age6to8:
                  "Sara discovered a glowing door behind the library shelf, shining like moonlight.",
              age9to12:
                  "Sara uncovered a moonlit door hidden in the old library wall, radiating silver light and mystery.",
            ),
            _byAge(
              age3to5: "A soft dragon said hello. Sara looked amazed.",
              age6to8:
                  "A gentle dragon greeted her and showed a sky full of floating lanterns.",
              age9to12:
                  "A gentle dragon guide welcomed her into a floating city of lanterns, and Sara watched in awe.",
            ),
            _byAge(
              age3to5: "She listened and said each sound slowly and clearly.",
              age6to8:
                  "She listened carefully and repeated each practice sound with wonder and focus.",
              age9to12:
                  "Inspired by the magical world, she practiced each target sound slowly, clearly, and with curiosity.",
            ),
          ],
        );
      case "Adventure":
        return _StoryTemplate(
          title: "The Hidden Map Trail",
          emoji: "MAP",
          lines: [
            _byAge(
              age3to5: "A map led Aru to a red box near the school tree.",
              age6to8:
                  "Aru followed a map trail across the playground to find a red clue box.",
              age9to12:
                  "Aru traced coded clues across the school grounds and located a red checkpoint box.",
            ),
            _byAge(
              age3to5: "Each clue was fun. Aru felt brave.",
              age6to8:
                  "Each clue made the adventure more exciting, and Aru felt brave and focused.",
              age9to12:
                  "Each solved clue raised the stakes, and Aru stayed calm, bold, and determined.",
            ),
            _byAge(
              age3to5: "At the end, Aru practiced clear speech words.",
              age6to8:
                  "At the finish, Aru repeated target words clearly like a real explorer.",
              age9to12:
                  "At the final marker, Aru practiced target sounds with precise, steady speech.",
            ),
          ],
        );
      case "Animals":
        return _StoryTemplate(
          title: "Zoo Helper Day",
          emoji: "ZOO",
          lines: [
            _byAge(
              age3to5: "Lia fed a rabbit and waved at a sleepy bear.",
              age6to8:
                  "Lia helped feed rabbits and watched a curious bear roll in the grass.",
              age9to12:
                  "Lia joined the zoo helpers, feeding rabbits and observing a bear's playful behavior.",
            ),
            _byAge(
              age3to5: "The animals made funny sounds. Lia smiled.",
              age6to8:
                  "Funny animal sounds made everyone smile and listen closely.",
              age9to12:
                  "The mix of chirps, growls, and squeaks kept the group engaged and attentive.",
            ),
            _byAge(
              age3to5: "Lia practiced speech sounds in a calm voice.",
              age6to8:
                  "Lia repeated her speech words softly and clearly before going home.",
              age9to12:
                  "Before leaving, Lia rehearsed her target sounds with calm pacing and clear articulation.",
            ),
          ],
        );
      case "Sports":
        return _StoryTemplate(
          title: "Final Whistle Run",
          emoji: "RUN",
          lines: [
            _byAge(
              age3to5: "Nina ran to the line and got a bright star sticker.",
              age6to8:
                  "Nina sprinted to the finish line while her team cheered loudly.",
              age9to12:
                  "Nina pushed through the final stretch, hearing her team chant from the sidelines.",
            ),
            _byAge(
              age3to5: "Her friends clapped and cheered.",
              age6to8:
                  "After the whistle, everyone high-fived and celebrated good teamwork.",
              age9to12:
                  "At the final whistle, the team celebrated discipline, effort, and smart communication.",
            ),
            _byAge(
              age3to5: "Then Nina practiced clear sounds slowly.",
              age6to8:
                  "After the race, Nina practiced her target sounds with steady breathing.",
              age9to12:
                  "After cooldown, Nina practiced her target words with rhythm, breath control, and clear speech.",
            ),
          ],
        );
      case "Science Fiction":
        return _StoryTemplate(
          title: "The Class Space Project",
          emoji: "SPACE",
          lines: [
            _byAge(
              age3to5: "Ria made a tiny rocket with shiny paper.",
              age6to8:
                  "Ria and her class built a model rocket and counted down together.",
              age9to12:
                  "Ria's team engineered a classroom rocket model and documented each launch test.",
            ),
            _byAge(
              age3to5: "It zoomed a little. Everyone said wow.",
              age6to8:
                  "When it launched, the class gasped and shouted with excitement.",
              age9to12:
                  "The successful launch sparked excitement, and the team analyzed how to improve stability.",
            ),
            _byAge(
              age3to5: "Ria practiced her speech sounds like a space captain.",
              age6to8:
                  "Ria repeated target words clearly like mission commands.",
              age9to12:
                  "Ria practiced her target sounds with crisp, command-style pronunciation.",
            ),
          ],
        );
      case "Mystery":
        return _StoryTemplate(
          title: "The Missing Notebook",
          emoji: "CLUE",
          lines: [
            _byAge(
              age3to5: "A notebook was gone. Tia looked under the desk.",
              age6to8:
                  "When a notebook disappeared, Tia followed tiny clues around the room.",
              age9to12:
                  "After a notebook vanished, Tia investigated labels, footprints, and class schedules.",
            ),
            _byAge(
              age3to5: "She found it in the reading corner. Surprise.",
              age6to8:
                  "She solved the mystery by finding it in the reading corner basket.",
              age9to12:
                  "She solved the case by tracing a pattern of clues to the reading corner shelf.",
            ),
            _byAge(
              age3to5: "Then she practiced her speech words.",
              age6to8:
                  "Then she repeated her target sounds clearly and slowly.",
              age9to12:
                  "Then she practiced her target words with controlled pace and precise pronunciation.",
            ),
          ],
        );
      case "Superhero":
        return _StoryTemplate(
          title: "The Quiet Hero",
          emoji: "HERO",
          lines: [
            _byAge(
              age3to5: "Rey wore a cape and helped a friend tie shoes.",
              age6to8:
                  "Rey used hero skills to help classmates share, clean up, and stay kind.",
              age9to12:
                  "Rey showed real hero values by solving small problems and helping younger students.",
            ),
            _byAge(
              age3to5: "Everyone cheered for kind actions.",
              age6to8:
                  "The class cheered because being kind was the best superpower.",
              age9to12:
                  "The class praised teamwork and empathy, proving leadership can be quiet and strong.",
            ),
            _byAge(
              age3to5: "Hero Rey practiced clear speech sounds.",
              age6to8:
                  "Hero Rey practiced target sounds with a brave, steady voice.",
              age9to12:
                  "Rey ended hero training by practicing target sounds with confidence and clarity.",
            ),
          ],
        );
      case "Friendship":
        return _StoryTemplate(
          title: "The Sharing Circle",
          emoji: "TEAM",
          lines: [
            _byAge(
              age3to5: "Mia and Sam shared crayons and drew a rainbow.",
              age6to8:
                  "Mia and Sam solved a small argument by sharing art tools and taking turns.",
              age9to12:
                  "Mia and Sam worked through a misunderstanding and rebuilt trust through teamwork.",
            ),
            _byAge(
              age3to5: "They smiled and played together.",
              age6to8:
                  "Their friendship grew stronger when they listened to each other.",
              age9to12:
                  "By listening and respecting each other, they turned conflict into cooperation.",
            ),
            _byAge(
              age3to5: "They practiced speech words with happy voices.",
              age6to8:
                  "They ended by repeating target sounds in calm, friendly voices.",
              age9to12:
                  "They finished by practicing target words with clear diction and supportive feedback.",
            ),
          ],
        );
      default:
        return _StoryTemplate(
          title: "School Garden Project",
          emoji: "GROW",
          lines: [
            _byAge(
              age3to5: "Kids planted seeds and gave them water.",
              age6to8: "The class planted a garden and cared for it each day.",
              age9to12:
                  "Students designed a garden plan, tracked plant growth, and presented their findings.",
            ),
            _byAge(
              age3to5: "Tiny leaves popped up. Everyone clapped.",
              age6to8: "When leaves appeared, everyone felt proud and excited.",
              age9to12:
                  "As the plants grew, the class reflected on patience, teamwork, and responsibility.",
            ),
            _byAge(
              age3to5: "Then they practiced clear speech sounds.",
              age6to8: "Then they practiced target sounds slowly and clearly.",
              age9to12:
                  "Then they practiced target words with structured pacing and precise articulation.",
            ),
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

  String _repeatWord(String word, int count) =>
      List.generate(count, (_) => word).join(", ");

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
    if (widget.practiceType == "Story")
      return repeat.isEmpty ? generateStory() : "${generateStory()}\n\n$repeat";
    if (widget.practiceType == "Song")
      return repeat.isEmpty ? generateSong() : "${generateSong()}\n\n$repeat";
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
      setState(
          () => _scoreMessage = "Microphone unavailable. Check permission.");
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
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Incorrect PIN")));
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
    final expected =
        _filterByTargetSound(_extractStoryKeywords()).take(8).toList();
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
    final recognizedWords = RegExp(r"[a-z]+")
        .allMatches(_recognizedText)
        .map((m) => m.group(0)!)
        .toSet();
    var missed = expected.where((w) => !recognizedWords.contains(w)).toList();
    if (missed.isEmpty) {
      missed = _filterByTargetSound(_ageAdjustedWords(_focusWords()));
    }

    setState(() {
      _score = percent;
      _hasAttemptedRetell = true;
      _practiceWords = _ageAdjustedWords(missed.take(5).toList());
      if (percent >= 85) {
        _scoreMessage = "Great job! Your speaking was very clear.";
      } else if (percent >= 60) {
        _scoreMessage = "Great effort! Try one more round for extra stars.";
      } else {
        _scoreMessage = "Great trying! Listen again and say each word slowly.";
      }
    });
  }

  List<String> _extractStoryKeywords() {
    final joined = _storyTemplate.lines
        .take(_storyLineCountByAge())
        .join(" ")
        .toLowerCase();
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
    if (widget.targetSound == "R")
      return words.where((w) => w.contains("r")).toList();
    if (widget.targetSound == "S")
      return words.where((w) => w.contains("s")).toList();
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final focused = _practiceWords;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: GestureDetector(
            onLongPress: _openParentDetails,
            child: const Text("Practice Time")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(_storyTemplate.emoji,
                          style: const TextStyle(fontSize: 56)),
                      const SizedBox(height: 6),
                      Text(_storyTemplate.title,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700)),
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
                  child: Text(generateContent(),
                      style: const TextStyle(fontSize: 18, height: 1.45)),
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
                const Text("Words To Practice",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: focused.map((word) {
                    return Card(
                      color: const Color(0xFFEDE7FF),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Text(word,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Practice Again")),
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
