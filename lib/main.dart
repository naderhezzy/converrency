import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:new_app/constants/app_colors.dart';
import 'package:new_app/screens/initial_screen.dart';
import 'package:new_app/providers/user_provider.dart';
import 'package:new_app/screens/converter_screen.dart';
import 'package:new_app/screens/saved_conversions_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: appColors,
      ),
      home: const InitialScreen(),
      routes: {
        ConverterScreen.screenRoute: (context) => const ConverterScreen(),
        SavedConversionsScreen.screenRoute: (context) =>
            const SavedConversionsScreen(),
      },
    );
  }
}
