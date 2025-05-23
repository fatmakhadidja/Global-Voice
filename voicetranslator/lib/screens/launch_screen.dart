import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                GradientText(text: 'Global Voice'),
                SizedBox(height: 10),
                MyText(
                  couleur: Colors.black,
                  fontfamily: 'Viga',
                  fontsize: 20,
                  fontweight: FontWeight.w400,
                  text:
                      'Effortlessly translate with\n AI into over 100+ languages',
                ),
              ],
            ),
            Image.asset('assets/images/launchScreenIllustrators.png'),
            ContinueButton(),
          ],
        ),
      ),
    );
  }
}
