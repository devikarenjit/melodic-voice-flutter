import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechPracticeScreen extends StatefulWidget {
  final String targetSound;

  const SpeechPracticeScreen({
    Key? key,
    required this.targetSound,
  }) : super(key: key);

  @override
  State<SpeechPracticeScreen> createState() => _SpeechPracticeScreenState();
}

class _SpeechPracticeScreenState extends State<SpeechPracticeScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechAvailable = false;
  String _spokenText = "";
  String feedback = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> startListening() async {
    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == "done" || status == "notListening") {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (error) {
        setState(() {
          _isListening = false;
          feedback = "Could not start microphone: ${error.errorMsg}";
        });
      },
    );

    _speechAvailable = available;

    if (!available) {
      setState(() {
        feedback =
            "Speech recognition unavailable. Check microphone permission in app settings.";
      });
      return;
    }

    setState(() {
      _isListening = true;
      feedback = "";
    });

    _speech.listen(
      onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords.toLowerCase();
        });
        analyzeSpeech(_spokenText);
      },
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: true,
      partialResults: true,
    );
  }

  void stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void analyzeSpeech(String text) {
    if (widget.targetSound == "R") {
      if (text.contains("w")) {
        feedback = "R sound incorrect. Try saying RRR like a lion.";
      } else {
        feedback = "Good R sound.";
      }
    }

    if (widget.targetSound == "S") {
      if (text.contains("th")) {
        feedback = "S sound incorrect. Keep tongue behind teeth.";
      } else {
        feedback = "Good S sound.";
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isError = feedback.toLowerCase().contains("incorrect") ||
        feedback.toLowerCase().contains("could not start") ||
        feedback.toLowerCase().contains("unavailable");
    final hasSpokenText = _spokenText.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Speak Now",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 38,
            letterSpacing: -0.6,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8F8FC),
              Color(0xFFF1F7FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF4E5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.graphic_eq_rounded,
                          color: Color(0xFF159A57),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Say a word with ${widget.targetSound} sound",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            color: const Color(0xFF181B32),
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: hasSpokenText
                          ? const Color(0xFF9EDDB9)
                          : const Color(0xFFE5E7F0),
                    ),
                  ),
                  child: Text(
                    hasSpokenText
                        ? _spokenText
                        : "Your speech will appear here...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: hasSpokenText ? FontWeight.w700 : FontWeight.w500,
                      color: hasSpokenText
                          ? const Color(0xFF1C2140)
                          : const Color(0xFF7C8198),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: feedback.isEmpty
                        ? const Color(0xFFF2F4F8)
                        : (isError
                            ? const Color(0xFFFFECEC)
                            : const Color(0xFFE8F8EF)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    feedback.isEmpty ? "Tap the mic and speak." : feedback,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: feedback.isEmpty
                          ? const Color(0xFF7F869D)
                          : (isError
                              ? const Color(0xFFC23A3A)
                              : const Color(0xFF1E8C52)),
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: _isListening ? 94 : 84,
                    height: _isListening ? 94 : 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isListening
                            ? const [Color(0xFFFF6D6D), Color(0xFFD93333)]
                            : const [Color(0xFF5BD182), Color(0xFF2FA861)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 14,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: _isListening ? stopListening : startListening,
                      iconSize: 40,
                      color: Colors.white,
                      icon: Icon(_isListening ? Icons.stop_rounded : Icons.mic_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _isListening ? "Listening..." : "Tap to start listening",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF646B83),
                  ),
                ),
                if (!_speechAvailable && feedback.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    "Open Settings > Apps > Melodic Voice > Permissions and allow Microphone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF646B83)),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
