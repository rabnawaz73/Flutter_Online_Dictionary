import 'package:wordwonder/Models/dictionary_model.dart';
import 'package:wordwonder/Screens/answer_Screen.dart';

import 'package:wordwonder/Screens/history.dart';
import 'package:wordwonder/Services/DicService.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool isLoading = false;
  String dataFound = '';
  String synonyms = '';
  String example = '';
  String partOfSpeech = '';
  DictionaryModel? myDictionaryModel;
  final TextEditingController controller = TextEditingController();
  final List<DictionaryModel> searchHistory = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Dropdown related variables
  String dropdownValue = 'English to English';

  void searchMean(String word) async {
    setState(() {
      isLoading = true;
    });

    try {
      myDictionaryModel = await DictionaryService.fetch(word);
      if (myDictionaryModel != null) {
        setState(() {
          isLoading = false;
          dataFound = myDictionaryModel!.word;
          synonyms = myDictionaryModel!.meanings[0].definitions[0].definition;
          example = myDictionaryModel!.meanings[0].definitions[0].definition;
          partOfSpeech = myDictionaryModel!.meanings[0].partOfSpeech;
          searchHistory.insert(0, myDictionaryModel!);
          _animationController.forward();

          // Update the current index to show the AnswerPage
          _currentIndex = 2;
        });
      } else {
        setState(() {
          isLoading = false;
          dataFound = '';
          synonyms = '';
          example = '';
          partOfSpeech = '';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        dataFound = '';
        synonyms = '';
        example = '';
        partOfSpeech = '';
      });
      print('Error fetching data: $e');
    }
  }

  final commonInputDecoration = InputDecoration(
    hintText: 'Enter word to search',
    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
    filled: true,
    fillColor: Colors.white,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide.none,
    ),
    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
    ),
  );

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
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
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text('Search'),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.history),
            title: const Text('History'),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.question_answer),
            title: const Text('Answer'),
            selectedColor: Colors.green,
          ),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.book, size: 32, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'WordWonder',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[800]!, Colors.pink[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildCurrentScreen(),
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
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return home();
      case 1:
        return SearchHistory(historyList: searchHistory);
      case 2:
        return AnswerPage(
          dictionaryModel: myDictionaryModel,
          word: dataFound.isEmpty ? 'Nothing is searched' : dataFound,
        );
      default:
        return home();
    }
  }

  Widget home() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Avatar with Local Asset Image
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/image.png'),
                ),
              ),

              // Decorative Dropdown Menu
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['English to English']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Search TextField
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  onSubmitted: (vale){
                    searchMean(controller.text);
                  },
                  keyboardType: TextInputType.text,
                  decoration: commonInputDecoration,
                  textInputAction: TextInputAction.done,
                ),
              ),

              const SizedBox(height: 24),

              // Beautiful Search Button
              ElevatedButton(
                onPressed: () {
                  searchMean(controller.text);
                  
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple[800], // Text color
                  shadowColor:
                      Colors.purpleAccent.withOpacity(0.5), // Shadow color
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded button
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15.0),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Loading Indicator or Results
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (dataFound.isNotEmpty)
                AnimatedOpacity(
                  opacity: _animation.value,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Translation: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: dataFound,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        if (partOfSpeech.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Part of Speech: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Example: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: example,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (synonyms.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Synonyms: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: synonyms,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
