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
