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
  var currentWidget;
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

          currentWidget =
              AnswerPage(dictionaryModel: myDictionaryModel, word: word);
        });

        // Navigate to the AnswerPage
      } else {
        // Handle the case where the API returns no data
        setState(() {
          isLoading = false;
          dataFound = '';
          synonyms = '';
          example = '';
          partOfSpeech = '';
        });
      }
    } catch (e) {
      // Handle the error
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
    hintText: 'Enter text',
    hintStyle: TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
  );

  final containerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: Colors.grey, width: 1.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              currentWidget = SearchScreen();
            });
          } else if (index == 1) {
            setState(() {
              currentWidget = const SearchHistory();
            });
          } else {
            currentWidget = AnswerPage(
              dictionaryModel: myDictionaryModel,
              word: 'Nothing is searched',
            );
          }
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
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
        title: Text('Search'),
      ),
      body: home(),
    );
  }

  Widget home() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
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
              SizedBox(height: 16),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (dataFound.isNotEmpty)
                AnimatedOpacity(
                  opacity: _animation.value,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    decoration: containerDecoration,
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
              SizedBox(height: 16),
              if (searchHistory.isEmpty)
                Center(
                  child: Text('No search history yet.',
                      style: TextStyle(fontSize: 16)),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    final entry = searchHistory[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(entry.word, style: TextStyle(fontSize: 18)),
                        subtitle: Text(
                          entry.meanings.isNotEmpty
                              ? entry.meanings[0].definitions[0].definition
                              : '',
                          style: TextStyle(fontSize: 16),
                        ),
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
