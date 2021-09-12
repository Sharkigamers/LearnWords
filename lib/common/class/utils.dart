import 'dart:convert';

class Utils {
  void clearDuplicate(Map<String, List<Map<String, dynamic>>> words) {
  words.forEach((String category, wordList) {
  words[category] = words[category]!
      .map((e) => jsonEncode(e))
      .toList()
      .toSet()
      .toList()
      .map((item) => (jsonDecode(item) as Map<String, dynamic>)).
  toList();
  });
  }
}