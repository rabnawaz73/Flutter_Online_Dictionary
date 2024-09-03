import 'package:dictionary/Models/dictionary_model.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatelessWidget {
  final DictionaryModel? dictionaryModel;
  const AnswerPage({super.key, required this.dictionaryModel, required String word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body:  SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildMainContent(),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dictionaryModel?.word ?? 'No word',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Here’s what we found for you:',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: ListView(
        children: [
          if (dictionaryModel?.meanings.isNotEmpty ?? false)
            _buildMeaningSection(dictionaryModel!),
          const SizedBox(height: 20),
          if (dictionaryModel?.meanings.isNotEmpty ?? false)
            _buildExamplesSection(dictionaryModel!),
          const SizedBox(height: 20),
          if (dictionaryModel?.meanings.isNotEmpty ?? false)
            _buildSynonymsSection(dictionaryModel!),
        ],
      ),
    );
  }

  Widget _buildMeaningSection(DictionaryModel model) {
    return _buildSectionContainer(
      color: Colors.lightBlue.shade50,
      title: 'Part of Speech',
      content: model.meanings[0].partOfSpeech ?? 'Unknown',
    );
  }

  Widget _buildExamplesSection(DictionaryModel model) {
    return _buildSectionContainer(
      color: Colors.lightGreen.shade50,
      title: 'Example',
      content: model.meanings[0].definitions[0].definition ?? 'No example available',
    );
  }

  Widget _buildSynonymsSection(DictionaryModel model) {
    return _buildSectionContainer(
      color: const Color.fromARGB(255, 228, 226, 209),
      title: 'Synonyms',
      content: model.meanings[0].definitions[0].definition ?? 'No synonyms available',
    );
  }

  Widget _buildSectionContainer({
    required Color color,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
