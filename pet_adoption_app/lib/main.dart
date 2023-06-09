import 'package:flutter/material.dart';
import 'package:pet_adoption_app/providers/providers.dart';
import 'package:pet_adoption_app/screens/screens.dart';
import 'package:pet_adoption_app/utils/utils.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await AppInit.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppInit.cacheAssetImages(context);
    AppInit.preCacheAllImages(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PetsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          context.read<ThemeProvider>().toggleTheme(
                AppInit.intialThemeMode() == ThemeMode.dark,
                notify: false,
              );
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pet Adoption App',
            theme: Styles.themeData(themeProvider.themeMode),
            home: AppInit.canIFillDataToIsar() ? const IntroScreen() : const HomeScreen(),
          );
        },
      ),
    );
  }
}
