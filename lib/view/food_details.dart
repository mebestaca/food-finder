import 'package:flutter/material.dart';

import '../model/recipe.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({Key? key}) : super(key: key);

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {

  @override
  Widget build(BuildContext context) {

    Recipe recipe = ModalRoute.of(context)?.settings.arguments as Recipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title ?? ""),
      ),
      body: Hero(
        tag: recipe.id.toString(),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(recipe.image ?? "")
            )
          ),
        )
      ),
    );
  }
}
