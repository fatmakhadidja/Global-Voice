import 'package:translator/translator.dart';

final Map<String, String> languages = {
  'Afrikaans': 'af',
  'Albanian': 'sq',
  'Arabic': 'ar',
  'Hebrew': 'iw',
  'Dutch': 'nl',
  'English': 'en',
  'Finnish': 'fi',
  'French': 'fr',
  'German': 'de',
  'Greek': 'el',
  'Icelandic': 'is',
  'Italian': 'it',
  'Japanese': 'ja',
  'Kannada': 'kn',
  'Korean': 'ko',
  'Norwegian': 'no',
  'Persian': 'fa',
  'Polish': 'pl',
  'Portuguese': 'pt',
  'Russian': 'ru',
  'Serbian': 'sr',
  'Spanish': 'es',
};

Future<String> translateText({
  required String text,
  required String sourceLanguage,
  required String targetLanguage,
}) async {
  if (text.trim().isEmpty) return '';

  final sourceCode = languages[sourceLanguage] ?? 'en';
  final targetCode = languages[targetLanguage] ?? 'ar';

  try {
    final translator = GoogleTranslator();
    var translation = await translator.translate(
      text,
      from: sourceCode,
      to: targetCode,
    );
    return translation.text;
  } catch (e) {
    throw Exception("Translation failed: $e");
  }
}

final translator = GoogleTranslator();
