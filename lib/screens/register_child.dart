import 'package:flutter/material.dart';
import '../services/parent_pin_service.dart';
import 'parent_settings.dart';
import 'practice_result.dart';

class RegisterChildScreen extends StatefulWidget {
  const RegisterChildScreen({Key? key}) : super(key: key);

  @override
  State<RegisterChildScreen> createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController difficultWordsController = TextEditingController();

  String selectedSound = "S";
  String selectedPosition = "Beginning";
  String? selectedGenre;
  String practiceType = "Story";

  final List<String> genres = [
    "Comedy",
    "Fantasy",
    "Friendship",
    "Adventure",
    "Mystery",
    "Science Fiction",
    "Superhero",
    "Fairy Tale",
    "Animals",
    "Sports",
  ];

  Future<void> _openParentSettings() async {
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect PIN")),
      );
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ParentSettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text("Melodic Voice"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openParentSettings,
            icon: const Icon(Icons.lock_outline),
            tooltip: "Parent Settings",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildCard(
              child: Column(
                children: [
                  const Text(
                    "Child Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    "Sound Practice",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedSound,
                    decoration: const InputDecoration(
                      labelText: "Target Sound",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "S", child: Text("S Sound")),
                      DropdownMenuItem(value: "R", child: Text("R Sound")),
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
                        child: Text("Beginning"),
                      ),
                      DropdownMenuItem(
                        value: "Middle",
                        child: Text("Middle"),
                      ),
                      DropdownMenuItem(
                        value: "End",
                        child: Text("End"),
                      ),
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
                      labelText: "Words to Practice (comma separated)",
                      helperText: "Use simple child-safe words only (example: sun, rabbit, star).",
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
                    "Choose Practice Type",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  RadioListTile(
                    title: const Text("Story"),
                    value: "Story",
                    groupValue: practiceType,
                    onChanged: (value) {
                      setState(() {
                        practiceType = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Song"),
                    value: "Song",
                    groupValue: practiceType,
                    onChanged: (value) {
                      setState(() {
                        practiceType = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Both"),
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
                    value: selectedGenre,
                    decoration: const InputDecoration(
                      labelText: "Favorite Genre",
                      border: OutlineInputBorder(),
                    ),
                    items: genres.map((genre) {
                      return DropdownMenuItem(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGenre = value;
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                if (selectedSound.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PracticeResultScreen(
                        name: nameController.text.trim().isEmpty
                            ? "Child"
                            : nameController.text.trim(),
                        preference: selectedGenre ?? "Adventure",
                        practiceType: practiceType,
                        difficultWords: difficultWordsController.text.trim(),
                        targetSound: selectedSound,
                        position: selectedPosition,
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "Generate Practice",
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
