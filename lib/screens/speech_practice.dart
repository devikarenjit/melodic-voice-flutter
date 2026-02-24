import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechPracticeScreen extends StatefulWidget {
  final String targetSound;

  const SpeechPracticeScreen({
    Key? key,
    required this.targetSound,
  }) : super(key: key);

  @override
  State<SpeechPracticeScreen> createState() =>
      _SpeechPracticeScreenState();
}

class _SpeechPracticeScreenState
    extends State<SpeechPracticeScreen> {

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "";
  String feedback = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() {
        _isListening = true;
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _spokenText =
                result.recognizedWords.toLowerCase();
          });

          analyzeSpeech(_spokenText);
        },
      );
    }
  }

  void stopListening() {
    _speech.stop();

    setState(() {
      _isListening = false;
    });
  }

  // 🔥 R / S Sound Detection Logic
  void analyzeSpeech(String text) {

    if (widget.targetSound == "R") {
      if (text.contains("w")) {
        feedback =
            "⚠️ R sound incorrect. Try saying RRR like a lion 🦁";
      } else {
        feedback = "✅ Good R sound!";
      }
    }

    if (widget.targetSound == "S") {
      if (text.contains("th")) {
        feedback =
            "⚠️ S sound incorrect. Keep tongue behind teeth.";
      } else {
        feedback = "✅ Good S sound!";
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎤 Speak Now"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "Say a word with ${widget.targetSound} sound",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              _spokenText.isEmpty
                  ? "Your speech will appear here..."
                  : _spokenText,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Text(
              feedback,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: feedback.contains("⚠️")
                    ? Colors.red
                    : Colors.green,
              ),
            ),

            const SizedBox(height: 50),

            FloatingActionButton(
              backgroundColor:
                  _isListening ? Colors.red : Colors.green,
              onPressed:
                  _isListening ? stopListening : startListening,
              child: Icon(
                _isListening
                    ? Icons.stop
                    : Icons.mic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}