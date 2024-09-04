import 'package:dictionary/Models/dictionary_model.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AnswerPage extends StatefulWidget {
  final DictionaryModel? dictionaryModel;
  final String word;

  const AnswerPage({super.key, required this.dictionaryModel, required this.word});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7871959041432035/2556069745',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
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
            if (_isAdLoaded)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
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
            widget.dictionaryModel?.word ?? 'No word',
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
          if (widget.dictionaryModel?.meanings.isNotEmpty ?? false)
            _buildMeaningSection(widget.dictionaryModel!),
          const SizedBox(height: 20),
          if (widget.dictionaryModel?.meanings.isNotEmpty ?? false)
            _buildExamplesSection(widget.dictionaryModel!),
          const SizedBox(height: 20),
          if (widget.dictionaryModel?.meanings.isNotEmpty ?? false)
            _buildSynonymsSection(widget.dictionaryModel!),
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
