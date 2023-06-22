import 'package:flutter/material.dart';
import 'package:expensetracker/presentation/pages/auth/login_page.dart';
import 'package:expensetracker/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  SharedPreferences.getInstance().then((instance) {
    String uid = '';
    if (instance.containsKey('uid')) {
      uid = instance.getString('uid') ?? '';
    }
    runApp(MyApp(hasSession: uid.isNotEmpty));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.hasSession
  });

  final bool hasSession;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: hasSession ? const HomePage() : const LoginPage(),
      debugShowCheckedModeBanner: false
    );
  }
}
