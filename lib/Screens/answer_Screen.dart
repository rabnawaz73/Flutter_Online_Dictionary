import 'package:dictionary/Models/dictionary_model.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatelessWidget {
  final DictionaryModel? dictionaryModel;
  const AnswerPage({super.key, required this.dictionaryModel, required String word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer for "${dictionaryModel?.word}"'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Translation: ${dictionaryModel?.word}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (dictionaryModel?.meanings.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Part of Speech: ${dictionaryModel?.meanings[0].partOfSpeech}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if (dictionaryModel?.meanings.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Example: ${dictionaryModel?.meanings[0].definitions[0].definition}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            if (dictionaryModel?.meanings.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Synonyms: ${dictionaryModel?.meanings[0].definitions[0].definition}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
