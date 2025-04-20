import 'package:flutter/material.dart';
import 'package:voice_translator/utils/constants.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientText(text: 'Global Voice'),
            SizedBox(
              width: 50,
              height: 50,
              child: LoadingIndicator(
                indicatorType: Indicator.ballBeat,

                colors: const [purple, pink, orange],

                strokeWidth: 2,

                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
