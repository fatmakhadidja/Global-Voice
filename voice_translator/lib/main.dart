import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_translator/screens/home_screen.dart';
import 'package:voice_translator/screens/launch_screen.dart';
import 'package:voice_translator/screens/splash_screen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      if (isFirstTime) {
        await prefs.setBool('isFirstTime', false);
        return const LaunchScreen();
      } else {
        return const SplashScreen();
      }
    } catch (e) {
      // Fallback in case of error
      return const Scaffold(body: Center(child: Text('Something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Translator',
      debugShowCheckedModeBanner: false,
      routes: {'/home': (context) => const HomeScreen()},
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Failed to load screen')),
            );
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            // This is just a final fallback
            return const Scaffold(
              body: Center(child: Text('Unexpected error')),
            );
          }
        },
      ),
    );
  }
}
