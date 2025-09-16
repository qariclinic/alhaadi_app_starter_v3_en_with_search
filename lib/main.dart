
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
void main() { runApp(const AlHaadiApp()); }
class AlHaadiApp extends StatelessWidget {
  const AlHaadiApp({super.key});
  @override Widget build(BuildContext context) {
    return MaterialApp(title: 'Al-Haadi', theme: ThemeData(primarySwatch: Colors.teal), debugShowCheckedModeBanner:false, home: const HomeScreen()); }
}
