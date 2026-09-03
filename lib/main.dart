import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PasswordGenApp());
}

class PasswordGenApp extends StatelessWidget {
  const PasswordGenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const GeneratorScreen(),
    );
  }
}

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  double _length = 14;
  bool _includeUppercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = lower;
    if (_includeUppercase) chars += upper;
    if (_includeNumbers) chars += numbers;
    if (_includeSymbols) chars += symbols;

    final rnd = Random.secure();
    setState(() {
      _password = List.generate(
        _length.round(),
        (_) => chars[rnd.nextInt(chars.length)],
      ).join();
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      _password,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Length', style: TextStyle(fontSize: 16)),
                        Text(
                          '${_length.round()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _length,
                      min: 6,
                      max: 32,
                      onChanged: (val) {
                        setState(() => _length = val);
                        _generatePassword();
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Uppercase Letters (A-Z)'),
                      value: _includeUppercase,
                      onChanged: (val) {
                        setState(() => _includeUppercase = val);
                        _generatePassword();
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Numbers (0-9)'),
                      value: _includeNumbers,
                      onChanged: (val) {
                        setState(() => _includeNumbers = val);
                        _generatePassword();
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Special Symbols (!@#\$)'),
                      value: _includeSymbols,
                      onChanged: (val) {
                        setState(() => _includeSymbols = val);
                        _generatePassword();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _generatePassword,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate New Password'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
