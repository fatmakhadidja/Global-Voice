import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:voice_translator/utils/constants.dart';
import 'package:voice_translator/services/services.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
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
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.black,
                            ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TranslationTextContainer(
                      size: 0.32,
                      linesNumber: 6,
                      controller: sourceCtrl,
                      language: selectedSourceLanguage,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TranslationTextContainer(
                      size: 0.32,
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
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MyText(
                          couleur: Colors.black,
                          fontfamily: 'Viga',
                          fontsize: 24,
                          fontweight: FontWeight.w400,
                          text: 'Global Voice',
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: VoiceTranslationContainer(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TranslationTextContainer(
                      size: 0.46,
                      linesNumber: 10,
                      controller: targetCtrl,
                      language: selectedSourceLanguage,
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
        );
      },
    );
  }
}
