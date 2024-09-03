import 'package:dictionary/Models/dictionary_model.dart';
import 'package:dictionary/Screens/answer_Screen.dart';

import 'package:dictionary/Screens/history.dart';
import 'package:dictionary/Services/DicService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class SearchScreen extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

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
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide.none,
    ),
    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.question_answer),
            title: Text('Answer'),
            selectedColor: Colors.green,
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Search Dictionary'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: _buildCurrentScreen(),
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
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Online Image
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Image.network(
                'https://images.unsplash.com/photo-1581092330016-3f09f0da3f54?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwzNjUyOXwwfDF8c2VhcmNofDJ8fGRpY3Rpb25hcnl8ZW58MHx8fHwxNjg3MTI4OTYx&ixlib=rb-1.2.1&q=80&w=800',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),

            // Dropdown Menu
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
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

            SizedBox(height: 20.0),

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
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: commonInputDecoration,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  searchMean(value);
                  controller.clear();
                },
              ),
            ),

            SizedBox(height: 24),

            // Loading Indicator or Results
            if (isLoading)
              Center(child: CircularProgressIndicator())
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
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Translation: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: dataFound,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      if (partOfSpeech.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Part of Speech: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: partOfSpeech,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (example.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Example: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: example,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (synonyms.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Synonyms: ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: synonyms,
                                  style: TextStyle(fontSize: 16),
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
    );
  }
}
