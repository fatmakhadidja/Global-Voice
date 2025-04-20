import 'package:flutter/material.dart';

const bgColor = Color(0xffF9F9F9);
const darkGrey = Color(0xff3A3A3A);
const lightGrey = Color(0xffBBBBBB);
const purple = Color(0xff4340CB);
const pink = Color(0xffCB40B5);
const orange = Color(0xffDE643E);

TextStyle gradientStyle = TextStyle(
  fontFamily: 'Viga',
  fontWeight: FontWeight.w400,
  fontSize: 28,
  foreground:
      Paint()
        ..shader = LinearGradient(
          colors: <Color>[purple, pink, orange],
        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
);

class GradientText extends StatelessWidget {
  final String text;
  const GradientText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: gradientStyle);
  }
}

class MyText extends StatelessWidget {
  final Color couleur;
  final double fontsize;
  final FontWeight fontweight;
  final String fontfamily;
  final String text;
  const MyText({
    super.key,
    required this.couleur,
    required this.fontfamily,
    required this.fontsize,
    required this.fontweight,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontfamily,
        fontSize: fontsize,
        fontWeight: fontweight,
        color: couleur,
      ),
    );
  }
}

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },

        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.black),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        child: MyText(
          couleur: Colors.white,
          fontfamily: 'Viga',
          fontsize: 14,
          fontweight: FontWeight.w400,
          text: 'Continue',
        ),
      ),
    );
  }
}

class TranslationTextContainer extends StatefulWidget {
  final double size;
  final int linesNumber;
  const TranslationTextContainer({
    super.key,
    required this.size,
    required this.linesNumber,
  });

  @override
  State<TranslationTextContainer> createState() =>
      _TranslationTextContainerState();
}

class _TranslationTextContainerState extends State<TranslationTextContainer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height * widget.size,

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 5, 0, 0),
            child: MyText(
              couleur: darkGrey,
              fontfamily: 'Viga',
              fontsize: 12,
              fontweight: FontWeight.w400,
              text: 'English',
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.multiline,
              maxLines: widget.linesNumber,
              decoration: const InputDecoration(
                hintText: "Enter text here ..",
                hintStyle: TextStyle(fontFamily: 'Viga', color: lightGrey),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(fontFamily: 'Viga', color: darkGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.volume_up_sharp, color: lightGrey, size: 25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BorderedButton extends StatefulWidget {
  final String buttomText;
  const BorderedButton({super.key, required this.buttomText});

  @override
  State<BorderedButton> createState() => _BorderedButtonState();
}

class _BorderedButtonState extends State<BorderedButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient border container
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.all(2), // Border thickness
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink, Colors.orange],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Button background
              borderRadius: BorderRadius.circular(18),
            ),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side:
                    BorderSide
                        .none, // No visible side (since border handled by gradient)
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: MyText(
                couleur: Colors.black,
                fontfamily: 'Viga',
                fontsize: 16,
                fontweight: FontWeight.w400,
                text: widget.buttomText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class VoiceTranslationContainer extends StatefulWidget {
  const VoiceTranslationContainer({super.key});

  @override
  State<VoiceTranslationContainer> createState() =>
      _VoiceTranslationContainerState();
}

class _VoiceTranslationContainerState extends State<VoiceTranslationContainer> {
  bool isRecording = false; // This keeps track of mic state

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
              couleur: isRecording ? Colors.red : darkGrey,
              fontfamily: 'Viga',
              fontsize: 17,
              fontweight: FontWeight.w500,
              text: isRecording ? 'Recording...' : 'Record here ..',
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isRecording = !isRecording;
                  });
                },
                icon: Icon(
                  isRecording ? Icons.stop_circle_outlined : Icons.mic,
                  size: 50,
                  color: isRecording ? Colors.red : darkGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
