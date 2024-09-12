// In the widget where you want to display the ad

import 'package:wordwonder/Models/dictionary_model.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordwonder/custom_native_ad.dart';

class SearchHistory extends StatefulWidget {
  final List<DictionaryModel> historyList;

  const SearchHistory({super.key, required this.historyList});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-7871959041432035/6263380462', // Replace with your Native Ad Unit ID
      factoryId: 'listTile', // Custom factory ID, not used here but can be if you had set it up in older versions
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Failed to load a native ad: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
    _nativeAd?.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.historyList.isEmpty
            ? const Center(
                child: Text(
                  'No search history yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: widget.historyList.length + 1,
                itemBuilder: (context, index) {
                  if (index == widget.historyList.length && _isNativeAdLoaded) {
                    return CustomNativeAd(ad: _nativeAd!);
                  } else if (index < widget.historyList.length) {
                    final entry = widget.historyList[index];
                    return Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        title: Text(
                          entry.word,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          entry.meanings.isNotEmpty
                              ? entry.meanings[0].definitions[0].definition
                              : 'No definition available',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            _showDeleteDialog(context, index);
                          },
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete History Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
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
  }
}
