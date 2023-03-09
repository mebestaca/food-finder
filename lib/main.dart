import 'package:flutter/material.dart';
import 'package:recipe_finder/shared/sharedTheme.dart';
import 'package:recipe_finder/view/food_details.dart';
import 'package:recipe_finder/view/home.dart';

import 'constants/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      home: const Home(),
      routes: {
        Routes.foodRoute : (context) => const FoodDetails()
      },
    );
  }
}

