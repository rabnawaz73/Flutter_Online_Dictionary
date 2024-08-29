

import 'package:dictionary/Models/dictionary_model.dart';
import 'package:dictionary/Services/DicService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState(); // Use concise syntax
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  var dataFound = '';
  var synonyms = '';
  var example = '';
  var partOfSpeech = '';
  DictionaryModel? myDictionaryModel;
  final TextEditingController controller = TextEditingController();

  List<DictionaryModel> searchHistory = [];

  void addToHistory(DictionaryModel entry) {
    setState(() {
      searchHistory.insert(0, entry); // Add new entry at the beginning
    });
  }

  void searchMean(var word) async {
    setState(() {
      isLoading = true;
    });
    try {
      myDictionaryModel = await DictionaryService.fetch(word);
      final definition = myDictionaryModel?.meanings[0].definitions[0].definition;
      setState(() {
        dataFound = definition ?? 'No Data Found';
        example = myDictionaryModel?.meanings[0].definitions[0].example ?? '';
        synonyms = (myDictionaryModel?.meanings[0].definitions[0].synonyms.join(', ') ?? '');
        // phonetic = myDictionaryModel?.meanings[0].definitions[0].phonetic ?? '';
        partOfSpeech = myDictionaryModel?.meanings[0].partOfSpeech ?? '';
        addToHistory(myDictionaryModel!);
      });
    } catch (e) {
      myDictionaryModel = null;
      setState(() {
        dataFound = 'No Meaning Found for the Given Text ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var commonInputDecoration = InputDecoration(
      hintText: 'Enter text',
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      ),
    );

    var containerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.grey, width: 1.0),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Ra',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'bn',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'aw',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'az',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: ' Translate',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 150,
                        child: RawKeyboardListener(
                          focusNode: FocusNode(),
                          onKey: (RawKeyEvent event) {
                            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                              searchMean(controller.text);
                              controller.clear();
                            }
                          },
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            controller: controller,
                            maxLines: null,
                            expands: true,
                            decoration: commonInputDecoration,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: 150,
                          child: Container(
                            decoration: containerDecoration,
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : Column(
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Translation: ',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: dataFound,
                                              style: const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (partOfSpeech.isNotEmpty)
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                const TextSpan(
                                                  text: 'Part of Speech: ',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: partOfSpeech,
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if (example.isNotEmpty)
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Example: ',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: example,
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (synonyms.isNotEmpty)
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                             const TextSpan(
                                                text: 'Synonyms: ',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: synonyms,
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ]
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              searchHistory.isEmpty // Handle empty history
                  ? const Center(child: Text('No search history yet.'))
                  : ListView.builder(
                shrinkWrap: true, // This is the key change
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  final entry = searchHistory[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(entry.word),
                      subtitle: Text(entry.meanings.isNotEmpty
                          ? entry.meanings[0].definitions[0].definition
                          : ''),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
