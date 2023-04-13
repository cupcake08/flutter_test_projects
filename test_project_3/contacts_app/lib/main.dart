import 'package:flutter/material.dart';
import 'package:contacts_app/screens/screens.dart';
import 'package:contacts_app/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SharedPrefs.isUserLoggedIn() ? const Home() : const LoginScreen(),
      home: Home(),
    );
  }
}
