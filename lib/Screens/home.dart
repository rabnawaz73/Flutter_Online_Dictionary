import 'package:dictionary/Models/dictionary_model.dart';
import 'package:dictionary/Screens/Search_Screen.dart';
import 'package:dictionary/Screens/answer_Screen.dart';
import 'package:dictionary/Services/DicService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String dataFound = '';
  String synonyms = '';
  String example = '';
  String partOfSpeech = '';
  DictionaryModel? myDictionaryModel;
  final TextEditingController controller = TextEditingController();
  List<DictionaryModel> searchHistory = [];

  void addToHistory(DictionaryModel entry) {
    setState(() {
      searchHistory.insert(0, entry);
    });
  }

  Future<void> searchMean(String word) async {
    setState(() {
      isLoading = true;
    });
    try {
      myDictionaryModel = await DictionaryService.fetch(word);
      final definition = myDictionaryModel?.meanings?[0].definitions?[0].definition;
      setState(() {
        dataFound = definition ?? 'No Data Found';
        example = myDictionaryModel?.meanings?[0].definitions?[0].example ?? '';
        synonyms = (myDictionaryModel?.meanings?[0].definitions?[0].synonyms?.join(', ') ?? '');
        partOfSpeech = myDictionaryModel?.meanings?[0].partOfSpeech ?? '';
        addToHistory(myDictionaryModel!);
      });
    } catch (e) {
      setState(() {
        dataFound = 'No Meaning Found for the Given Text ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 27, 27, 29),
        systemNavigationBarColor: Color.fromARGB(255, 27, 27, 29),
      ),
    );

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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text.rich(
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
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  Center(child: Text('No search history yet.', style: TextStyle(fontSize: 16)))
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
                          subtitle: Text(entry.meanings.isNotEmpty
                              ? entry.meanings[0].definitions[0].definition
                              : '',
                              style: TextStyle(fontSize: 16)),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            return DictionaryApp();
          } else if (index == 1) {
            return DictionaryHomePage();
          } else if (index == 2) {
            return AnswerPage(word: 'hello',);
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
    );
  }
}

