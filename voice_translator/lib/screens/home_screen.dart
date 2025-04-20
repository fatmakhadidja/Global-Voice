import 'package:flutter/material.dart';
import 'package:voice_translator/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Selected tab index
  int _selectedIndex = 0;

  // Widgets for each tab
  final List<Widget> _widgets = [
    const TextTranslation(key: ValueKey(0)), // Unique key for AnimatedSwitcher
    const VoiceTranslation(key: ValueKey(1)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset:
          true, // Automatically resize to avoid keyboard overflow
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
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
            child: TranslationTextContainer(size: 0.33, linesNumber: 6),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TranslationTextContainer(size: 0.33, linesNumber: 6),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BorderedButton(buttomText: 'English'),
                Icon(Icons.arrow_right_alt_outlined, color: lightGrey),
                BorderedButton(buttomText: 'Arabic'),
              ],
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TranslationTextContainer(size: 0.46, linesNumber: 10),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BorderedButton(buttomText: 'Auto'),
                Icon(Icons.arrow_right_alt_outlined, color: lightGrey),
                BorderedButton(buttomText: 'English'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
