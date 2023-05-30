import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:p_14_messanger/screens/login_screen.dart';

void main() async{
  // برای اطمینان از اجرا شدن ویجت ها و معلق نماندن برنامه
  WidgetsFlutterBinding.ensureInitialized();
  //شناساندن فایربیس
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
