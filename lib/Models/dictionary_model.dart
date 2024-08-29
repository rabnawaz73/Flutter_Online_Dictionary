/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
library;

import 'dart:convert';

DictionaryModel dictionaryModelFromJson(String str) => DictionaryModel.fromJson(json.decode(str));

String dictionaryModelToJson(DictionaryModel data) => json.encode(data.toJson());

class DictionaryModel {
    DictionaryModel({
        required this.license,
        required this.phonetics,
        required this.word,
        required this.meanings,
        required this.sourceUrls,
    });

    License license;
    List<Phonetic> phonetics;
    String word;
    List<Meaning> meanings;
    List<String> sourceUrls;

    factory DictionaryModel.fromJson(Map<dynamic, dynamic> json) => DictionaryModel(
        license: License.fromJson(json["license"]),
        phonetics: List<Phonetic>.from(json["phonetics"].map((x) => Phonetic.fromJson(x))),
        word: json["word"],
        meanings: List<Meaning>.from(json["meanings"].map((x) => Meaning.fromJson(x))),
        sourceUrls: List<String>.from(json["sourceUrls"].map((x) => x)),
    );

    Map<dynamic, dynamic> toJson() => {
        "license": license.toJson(),
        "phonetics": List<dynamic>.from(phonetics.map((x) => x.toJson())),
        "word": word,
        "meanings": List<dynamic>.from(meanings.map((x) => x.toJson())),
        "sourceUrls": List<dynamic>.from(sourceUrls.map((x) => x)),
    };
}

class License {
    License({
        required this.name,
        required this.url,
    });

    String name;
    String url;

    factory License.fromJson(Map<dynamic, dynamic> json) => License(
        name: json["name"],
        url: json["url"],
    );

    Map<dynamic, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}

class Meaning {
    Meaning({
        required this.synonyms,
        required this.partOfSpeech,
        required this.antonyms,
        required this.definitions,
    });

    List<String> synonyms;
    String partOfSpeech;
    List<String> antonyms;
    List<Definition> definitions;

    factory Meaning.fromJson(Map<dynamic, dynamic> json) => Meaning(
        synonyms: List<String>.from(json["synonyms"].map((x) => x)),
        partOfSpeech: json["partOfSpeech"],
        antonyms: List<String>.from(json["antonyms"].map((x) => x)),
        definitions: List<Definition>.from(json["definitions"].map((x) => Definition.fromJson(x))),
    );

    Map<dynamic, dynamic> toJson() => {
        "synonyms": List<dynamic>.from(synonyms.map((x) => x)),
        "partOfSpeech": partOfSpeech,
        "antonyms": List<dynamic>.from(antonyms.map((x) => x)),
        "definitions": List<dynamic>.from(definitions.map((x) => x.toJson())),
    };
}

class Definition {
    Definition({
        required this.synonyms,
        required this.antonyms,
        required this.definition,
        this.example,
    });

    List<dynamic> synonyms;
    List<dynamic> antonyms;
    String definition;
    String? example;

    factory Definition.fromJson(Map<dynamic, dynamic> json) => Definition(
        synonyms: List<dynamic>.from(json["synonyms"].map((x) => x)),
        antonyms: List<dynamic>.from(json["antonyms"].map((x) => x)),
        definition: json["definition"],
        example: json["example"],
    );

    Map<dynamic, dynamic> toJson() => {
        "synonyms": List<dynamic>.from(synonyms.map((x) => x)),
        "antonyms": List<dynamic>.from(antonyms.map((x) => x)),
        "definition": definition,
        "example": example,
    };
}

class Phonetic {
    Phonetic({
        this.sourceUrl,
        this.license,
        required this.audio,
        this.text,
    });

    String? sourceUrl;
    License? license;
    String audio;
    String? text;

    factory Phonetic.fromJson(Map<dynamic, dynamic> json) => Phonetic(
        sourceUrl: json["sourceUrl"],
        license: json["license"] == null ? null : License.fromJson(json["license"]),
        audio: json["audio"],
        text: json["text"],
    );

    Map<dynamic, dynamic> toJson() => {
        "sourceUrl": sourceUrl,
        "license": license?.toJson(),
        "audio": audio,
        "text": text,
    };
}
