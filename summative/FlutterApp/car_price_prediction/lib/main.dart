import 'package:flutter/material.dart';
import 'package:car_price_prediction/screens/form_screen.dart';
import 'package:car_price_prediction/screens/result_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Price Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormScreen(),
      routes: {
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}
