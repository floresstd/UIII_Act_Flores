import 'package:firebasenotes/notes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD0YGTvNTbiaFiQ0EThbyGNk94Op33yMG8", 
      appId: "1:943164385053:android:561fd25c8aab12093c23f4", 
      messagingSenderId: "943164385053", 
      projectId: "notasapp-e05a5"),

  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Note());
  }
}
