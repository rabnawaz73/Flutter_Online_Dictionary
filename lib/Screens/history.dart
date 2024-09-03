import 'package:dictionary/Models/dictionary_model.dart';
import 'package:flutter/material.dart';

class SearchHistory extends StatefulWidget {
  final List<DictionaryModel> historyList;

  SearchHistory({super.key, required this.historyList});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.historyList.isEmpty
            ? Center(
                child: Text(
                  'No search history yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: widget.historyList.length,
                itemBuilder: (context, index) {
                  final entry = widget.historyList[index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      title: Text(
                        entry.word,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        entry.meanings.isNotEmpty
                            ? entry.meanings[0].definitions[0].definition
                            : 'No definition available',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          // Show a dialog to confirm deletion
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete History Item'),
                                content: Text('Are you sure you want to delete this item?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      setState(() {
                                        widget.historyList.removeAt(index);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
