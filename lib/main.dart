import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';
import 'config/theme.dart';

void main() {
  runApp(MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDB Movie App',
      theme: AppTheme.darkTheme,
      home: HomeScreen(),
    );
  }
}
