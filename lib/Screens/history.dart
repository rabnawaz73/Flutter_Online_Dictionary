import 'package:flutter/material.dart';


class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  State<SearchHistory> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<SearchHistory> {
  String _selectedLanguage = 'English (US)';
  String _enteredWord = '';
  String _definition = '';
  List<SearchHistoryItem> _searchHistory = [];

  void _searchWord() async {
    // Implement your search logic here, potentially using a dictionary API
    // Replace the placeholder with your actual API call
    final apiResponse = await _fetchDefinition(_enteredWord);

    setState(() {
      _definition = apiResponse;
      _searchHistory.insert(0, SearchHistoryItem(_enteredWord, _selectedLanguage));
    });
  }

  Future<String> _fetchDefinition(String word) async {
    // Replace this with your actual API call
    return 'Definition for "$word": ...';
  }

  void _clearHistory() {
    setState(() {
      _searchHistory.clear();
    });
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
            const SizedBox(height: 16.0),
            if (_searchHistory.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Search History', style: TextStyle(fontWeight: FontWeight.bold)), 

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final historyItem = _searchHistory[index];
                      return ListTile(
                        title: Text(historyItem.word),
                        subtitle: Text(historyItem.language),
                        trailing: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchHistory.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            if (_searchHistory.isNotEmpty)
              ElevatedButton(
                onPressed: _clearHistory,
                child: const Text('Clear History'),
              ),
          ],
        ),
      ),

    );
  }
}

class SearchHistoryItem {
  final String word;
  final String language;

  SearchHistoryItem(this.word, this.language);
}