import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Models/dictionary_model.dart';

class DictionaryService{
  static String url = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

  static Future<DictionaryModel?> fetch(String word) async{
        try{
      final response = await http.get(Uri.parse('$url$word'));
      if(response.statusCode == 200){
        var decode = json.decode(response.body);
         return DictionaryModel.fromJson(decode[0]);

      }
    }catch(e){
      throw Exception(e.toString());
    }
        return null;


  }
}