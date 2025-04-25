import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../utils/constants.dart';
import '../services/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

// Global functions for reuse
void showLanguagePicker(
  BuildContext context,
  bool isSource,
  String selectedSourceLanguage,
  String selectedTargetLanguage,
  Function(String, bool) onLanguageSelected,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages.keys.elementAt(index);
          return ListTile(
            title: Text(language),
            onTap: () {
              onLanguageSelected(language, isSource);
              Navigator.pop(context);
            },
          );
        },
      );
    },
  );
}

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
    debugPrint("Error during translation: $e");
    throw Exception("Translation failed: $e");
  }
}

// Main HomeScreen widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Use const constructor to avoid unnecessary rebuilds
  final List<Widget> _widgets = const [
    TextTranslation(key: ValueKey(0)),
    VoiceTranslation(key: ValueKey(1)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _widgets[_selectedIndex],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: lightGrey,
          onTap: (index) {
            if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.text_fields),
              label: 'Text Translation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.voice_chat),
              label: 'Voice Translation',
            ),
          ],
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}

// Text Translation Screen
class TextTranslation extends StatefulWidget {
  const TextTranslation({super.key});

  @override
  State<TextTranslation> createState() => _TextTranslationState();
}

class _TextTranslationState extends State<TextTranslation> {
  final TextEditingController sourceCtrl = TextEditingController();
  final TextEditingController targetCtrl = TextEditingController();
  String selectedSourceLanguage = 'English';
  String selectedTargetLanguage = 'Arabic';

  @override
  void dispose() {
    // Properly dispose controllers to prevent memory leaks
    sourceCtrl.dispose();
    targetCtrl.dispose();
    super.dispose();
  }

  void _handleLanguageSelection(String language, bool isSource) {
    setState(() {
      if (isSource) {
        selectedSourceLanguage = language;
        sourceCtrl.text = '';
      } else {
        selectedTargetLanguage = language;
        targetCtrl.text = '';
      }
    });
  }

  Future<void> _performTranslation() async {
    try {
      final result = await translateText(
        text: sourceCtrl.text,
        sourceLanguage: selectedSourceLanguage,
        targetLanguage: selectedTargetLanguage,
      );

      if (mounted) {
        setState(() {
          targetCtrl.text = result;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Translation failed: $e')));
      }
    }
  }

  void _swapLanguages() {
    setState(() {
      final tempLang = selectedSourceLanguage;
      selectedSourceLanguage = selectedTargetLanguage;
      selectedTargetLanguage = tempLang;

      final tempText = sourceCtrl.text;
      sourceCtrl.text = targetCtrl.text;
      targetCtrl.text = tempText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MyText(
                  couleur: Colors.black,
                  fontfamily: 'Viga',
                  fontsize: 24,
                  fontweight: FontWeight.w400,
                  text: 'Global Voice',
                ),
                ElevatedButton(
                  onPressed: _performTranslation,
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black),
                  ),
                  child: const MyText(
                    couleur: Colors.white,
                    fontfamily: 'Viga',
                    fontsize: 12,
                    fontweight: FontWeight.w400,
                    text: 'Translate',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TranslationTextContainer(
                      size: 0.34,
                      linesNumber: 6,
                      controller: sourceCtrl,
                      language: selectedSourceLanguage,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TranslationTextContainer(
                      size: 0.34,
                      linesNumber: 6,
                      controller: targetCtrl,
                      language: selectedTargetLanguage,
                    ),
                  ),
                  _buildLanguageSelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BorderedButton(
            buttonText: selectedSourceLanguage,
            whenpressed:
                () => showLanguagePicker(
                  context,
                  true,
                  selectedSourceLanguage,
                  selectedTargetLanguage,
                  _handleLanguageSelection,
                ),
          ),
          IconButton(
            onPressed: _swapLanguages,
            icon: const Icon(Icons.compare_arrows, color: lightGrey),
          ),
          BorderedButton(
            buttonText: selectedTargetLanguage,
            whenpressed:
                () => showLanguagePicker(
                  context,
                  false,
                  selectedSourceLanguage,
                  selectedTargetLanguage,
                  _handleLanguageSelection,
                ),
          ),
        ],
      ),
    );
  }
}

// Voice Translation Screen
class VoiceTranslation extends StatefulWidget {
  const VoiceTranslation({super.key});

  @override
  State<VoiceTranslation> createState() => _VoiceTranslationState();
}

class _VoiceTranslationState extends State<VoiceTranslation> {
  String selectedSourceLanguage = 'English';
  String selectedTargetLanguage = 'Arabic';
  final TextEditingController targetCtrl = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = "";

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    targetCtrl.dispose();
    super.dispose();
  }

  void _handleLanguageSelection(String language, bool isSource) {
    setState(() {
      if (isSource) {
        selectedSourceLanguage = language;
      } else {
        selectedTargetLanguage = language;
        targetCtrl.text = '';
      }
    });
  }

  Future<void> _checkPermissions() async {
    if (await Permission.microphone.request().isGranted) {
      debugPrint("Microphone permission granted");
      _initSpeech();
    } else {
      debugPrint("Microphone permission denied");
    }
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint("Speech status: $status"),
      onError: (error) {
        debugPrint("Speech error: $error");
        setState(() => _isListening = false);
      },
    );

    if (!available) {
      debugPrint("Speech recognition is not available on this device.");
    }
  }

  void _toggleListening() async {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint("Speech status: $status"),
      onError: (error) {
        debugPrint("Speech error: $error");
        setState(() => _isListening = false);
      },
    );

    if (available) {
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
          });
        },
        listenMode: stt.ListenMode.dictation,
        partialResults: true,
      );
      setState(() => _isListening = true);
    } else {
      debugPrint("Speech recognition not available.");
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    _translateSpokenText();
  }

  Future<void> _translateSpokenText() async {
    if (_spokenText.trim().isEmpty) return;

    try {
      final result = await translateText(
        text: _spokenText,
        sourceLanguage: selectedSourceLanguage,
        targetLanguage: selectedTargetLanguage,
      );

      if (mounted) {
        setState(() {
          targetCtrl.text = result;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Translation failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Global Voice',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Viga',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          VoiceTranslationContainer(
            spokenText: _spokenText,
            isListening: _isListening,
            onPressMic: _toggleListening,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TranslationTextContainer(
                      size: 0.46,
                      linesNumber: 10,
                      controller: targetCtrl,
                      language: selectedTargetLanguage,
                    ),
                  ),
                  _buildLanguageSelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BorderedButton(
            buttonText: selectedSourceLanguage,
            whenpressed:
                () => showLanguagePicker(
                  context,
                  true,
                  selectedSourceLanguage,
                  selectedTargetLanguage,
                  _handleLanguageSelection,
                ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                final tempLang = selectedSourceLanguage;
                selectedSourceLanguage = selectedTargetLanguage;
                selectedTargetLanguage = tempLang;
              });
            },
            icon: const Icon(Icons.compare_arrows, color: lightGrey),
          ),
          BorderedButton(
            buttonText: selectedTargetLanguage,
            whenpressed:
                () => showLanguagePicker(
                  context,
                  false,
                  selectedSourceLanguage,
                  selectedTargetLanguage,
                  _handleLanguageSelection,
                ),
          ),
        ],
      ),
    );
  }
}

