import 'package:contacts_app/notifiers/contacts_notifier.dart';
import 'package:flutter/material.dart';
import 'package:contacts_app/screens/screens.dart';
import 'package:contacts_app/utils/utils.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ContactsNotifier())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SharedPrefs.isUserLoggedIn() ? const Home() : const LoginScreen(),
      ),
    );
  }
}
