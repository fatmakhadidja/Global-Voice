import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../utils/constants.dart';
import '../services/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgets = [
    const TextTranslation(key: ValueKey(0)),
    const VoiceTranslation(key: ValueKey(1)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset:
          true, // Ensures the UI resizes when the keyboard is shown
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
            setState(() {
              _selectedIndex = index;
            });
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

class TextTranslation extends StatefulWidget {
  const TextTranslation({super.key});

  @override
  State<TextTranslation> createState() => _TextTranslationState();
}

class _TextTranslationState extends State<TextTranslation> {
  TextEditingController sourceCtrl = TextEditingController();
  TextEditingController targetCtrl = TextEditingController();
  String selectedSourceLanguage = 'English';
  String selectedTargetLanguage = 'Arabic';
  GoogleTranslator translator = GoogleTranslator();

  void showLanguagePicker(bool isSource, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children:
              languages.keys
                  .map(
                    (language) => ListTile(
                      title: Text(language),
                      onTap: () {
                        setState(() {
                          if (isSource) {
                            selectedSourceLanguage = language;
                            sourceCtrl.text = '';
                          } else {
                            selectedTargetLanguage = language;
                            targetCtrl.text = '';
                          }
                        });
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Future<void> translateText() async {
    final sourceCode = languages[selectedSourceLanguage] ?? 'en';
    final targetCode = languages[selectedTargetLanguage] ?? 'ar';
    final text = sourceCtrl.text;

    try {
      var translation = await translator.translate(
        text,
        from: sourceCode,
        to: targetCode,
      );
      setState(() {
        targetCtrl.text = translation.text;
      });
    } catch (e) {
      print("Error during translation: $e");
    }
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
                MyText(
                  couleur: Colors.black,
                  fontfamily: 'Viga',
                  fontsize: 24,
                  fontweight: FontWeight.w400,
                  text: 'Global Voice',
                ),
                ElevatedButton(
                  onPressed: translateText,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                  ),
                  child: MyText(
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
          // Use Expanded to make sure the input fields don't overflow when the keyboard appears
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BorderedButton(
                          buttonText: selectedSourceLanguage,
                          whenpressed: () => showLanguagePicker(true, context),
                        ),
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: lightGrey,
                        ),
                        BorderedButton(
                          buttonText: selectedTargetLanguage,
                          whenpressed: () => showLanguagePicker(false, context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoiceTranslation extends StatefulWidget {
  const VoiceTranslation({super.key});

  @override
  State<VoiceTranslation> createState() => _VoiceTranslationState();
}

class _VoiceTranslationState extends State<VoiceTranslation> {
  String selectedSourceLanguage = 'Auto';
  String selectedTargetLanguage = 'English';
  TextEditingController targetCtrl = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _spokenText = "";

  @override
  void initState() {
    super.initState();
    _checkPermissions(); // Ask for mic permission
  }

  Future<void> _checkPermissions() async {
    if (await Permission.microphone.request().isGranted) {
      print("Microphone permission granted");
      _initSpeech();
    } else {
      print("Microphone permission denied");
    }
  }

  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print("Speech status: $status"),
      onError: (error) {
        print("Speech error: $error");
        setState(() => _isListening = false);
      },
    );

    if (!available) {
      print("Speech recognition is not available on this device.");
    }
  }

  void showLanguagePicker(bool isSource, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: languages.keys
              .map(
                (language) => ListTile(
                  title: Text(language),
                  onTap: () {
                    setState(() {
                      if (isSource) {
                        selectedSourceLanguage = language;
                      } else {
                        selectedTargetLanguage = language;
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        );
      },
    );
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
      onStatus: (status) => print("Speech status: $status"),
      onError: (error) {
        print("Speech error: $error");
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
      print("Speech recognition not available.");
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    _translateText();
  }

  Future<void> _translateText() async {
    final sourceCode = languages[selectedSourceLanguage] ?? 'auto';
    final targetCode = languages[selectedTargetLanguage] ?? 'en';

    try {
      var translation = await GoogleTranslator().translate(
        _spokenText,
        from: sourceCode,
        to: targetCode,
      );
      setState(() {
        targetCtrl.text = translation.text;
      });
    } catch (e) {
      print("Translation failed: $e");
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
            isListening: _isListening,  // Pass the listening state
            onPressMic: _toggleListening, // This will toggle start/stop listening
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BorderedButton(
                          buttonText: selectedSourceLanguage,
                          whenpressed: () => showLanguagePicker(true, context),
                        ),
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.grey,
                        ),
                        BorderedButton(
                          buttonText: selectedTargetLanguage,
                          whenpressed: () => showLanguagePicker(false, context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoiceTranslationContainer extends StatelessWidget {
  final String spokenText;
  final bool isListening;
  final VoidCallback onPressMic;

  const VoiceTranslationContainer({
    super.key,
    required this.spokenText,
    required this.isListening,
    required this.onPressMic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              couleur: isListening ? Colors.red : darkGrey,
              fontfamily: 'Viga',
              fontsize: 17,
              fontweight: FontWeight.w500,
              text: isListening ? 'Recording...' : 'Record here ..',
            ),
            Center(
              child: IconButton(
                onPressed: onPressMic, // This will toggle start/stop listening
                icon: Icon(
                  isListening ? Icons.stop_circle_outlined : Icons.mic,
                  size: 50,
                  color: isListening ? Colors.red : darkGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
