import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Assuming Google Fonts is used

class DictionaryApp extends StatelessWidget {
  const DictionaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.roboto().fontFamily, // Use Roboto font for a clean look
      ),
      home: const DictionaryHomePage(),
    );
  }
}

class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
  State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  String _selectedLanguage = 'English (US)';
  String _enteredWord = '';
  String _definition = '';

  void _searchWord() async {
    // Implement your search logic here, potentially using a dictionary API
    // Replace the placeholder with your actual API call
    final apiResponse = await _fetchDefinition(_enteredWord);

    setState(() {
      _definition = apiResponse;
    });
  }

  Future<String> _fetchDefinition(String word) async {
    // Replace this with your actual API call
    return 'Definition for "$word": ...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_medium),
            onPressed: () {
              // Implement your theme switching logic here
              // For example, you could use a provider or state management solution
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'English (US)', child: Text('English (US)')),
                // Add other language options as needed
              ],
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _enteredWord = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter a word',
              ),
            ),
            ElevatedButton(
              onPressed: _searchWord,
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            Text(
              _definition,
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}