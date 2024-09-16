import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speakprompt/controllers/ai_controller.dart';
import 'package:speakprompt/home.dart';

void main() {
  runApp(ChangeNotifierProvider<AIcontroller>
  (
    create: (context) => AIcontroller(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

