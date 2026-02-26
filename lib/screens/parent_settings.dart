import 'package:flutter/material.dart';
import '../services/parent_pin_service.dart';

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  final TextEditingController currentPinController = TextEditingController();
  final TextEditingController newPinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  String _message = "";

  @override
  void dispose() {
    currentPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _savePin() async {
    final current = currentPinController.text.trim();
    final newPin = newPinController.text.trim();
    final confirm = confirmPinController.text.trim();
    final savedPin = await ParentPinService.getPin();

    if (current != savedPin) {
      setState(() => _message = "Current PIN is incorrect.");
      return;
    }

    if (newPin.length != 4 || int.tryParse(newPin) == null) {
      setState(() => _message = "New PIN must be exactly 4 digits.");
      return;
    }

    if (newPin != confirm) {
      setState(() => _message = "New PIN and confirm PIN do not match.");
      return;
    }

    await ParentPinService.setPin(newPin);
    setState(() => _message = "PIN updated successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Parent Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: currentPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Current PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New PIN (4 digits)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm New PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePin,
                child: const Text("Save PIN"),
              ),
            ),
            const SizedBox(height: 12),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _message.contains("success")
                      ? Colors.green
                      : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
