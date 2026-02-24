import 'package:flutter/material.dart';
import 'practice_result.dart';
import 'speech_practice.dart';

class RegisterChildScreen extends StatefulWidget {
  const RegisterChildScreen({Key? key}) : super(key: key);

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController difficultWordsController =
      TextEditingController();

  String selectedSound = "S";
  String selectedPosition = "Beginning";
  String? selectedPreference;
  String practiceType = "Story";

  final List<String> preferences = [
    "Animals 🐶",
    "Princess 👑",
    "Space 🚀",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Soft peach background
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text("🎵 Melodic Voice"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            buildCard(
              child: Column(
                children: [
                  const Text(
                    "👶 Child Information",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Child Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "🎯 Sound Practice",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: selectedSound,
                    decoration: const InputDecoration(
                      labelText: "Target Sound",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: "S", child: Text("S Sound 🐍")),
                      DropdownMenuItem(
                          value: "R", child: Text("R Sound 🚗")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSound = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: selectedPosition,
                    decoration: const InputDecoration(
                      labelText: "Sound Position",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: "Beginning",
                          child: Text("Beginning 🌟")),
                      DropdownMenuItem(
                          value: "Middle",
                          child: Text("Middle ⭐")),
                      DropdownMenuItem(
                          value: "End",
                          child: Text("End 🎯")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedPosition = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: difficultWordsController,
                    decoration: const InputDecoration(
                      labelText:
                          "Words to Practice (comma separated)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "📖 Choose Practice Type",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),

                  RadioListTile(
                    title: const Text("Story 📚"),
                    value: "Story",
                    groupValue: practiceType,
                    onChanged: (value) {
                      setState(() {
                        practiceType = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    title: const Text("Song 🎵"),
                    value: "Song",
                    groupValue: practiceType,
                    onChanged: (value) {
                      setState(() {
                        practiceType = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    title: const Text("Both 🎉"),
                    value: "Both",
                    groupValue: practiceType,
                    onChanged: (value) {
                      setState(() {
                        practiceType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: selectedPreference,
                    decoration: const InputDecoration(
                      labelText: "Theme",
                      border: OutlineInputBorder(),
                    ),
                    items: preferences.map((pref) {
                      return DropdownMenuItem(
                        value: pref,
                        child: Text(pref),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPreference = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                    vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
  if (selectedSound != null && selectedSound.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeechPracticeScreen(
          targetSound: selectedSound,
        ),
      ),
    );
  }
}
              child: const Text(
                "✨ Generate Practice",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({required Widget child}) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}