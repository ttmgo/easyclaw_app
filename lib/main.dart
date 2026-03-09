import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'EasyClaw',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEF4444)),
          useMaterial3: true,
          fontFamily: 'Inter',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
