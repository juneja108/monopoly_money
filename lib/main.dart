import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:monopoly_money/pages/home.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(BaseApp());
}

class BaseApp extends StatelessWidget {
  BaseApp({super.key});

  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Monopoly Money")
        ),
        body: MainApp(pageController: pageController)
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.pageController});

  final PageController pageController;
  
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        JoinScreen()
      ],
    );
  }}