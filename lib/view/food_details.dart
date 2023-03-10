import 'package:flutter/material.dart';
import 'package:recipe_finder/shared/sharedListTile.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/food_background.jpg"),
                    fit: BoxFit.cover
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8
                    ),
                    child: Card(
                      child: ListTile(
                        subtitle: Text(
                          recipe.title.toString(),
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                        title: Hero(
                          tag: recipe.id.toString(),
                          child: Image.network(
                            recipe.image ?? "",
                            fit: BoxFit.fill,
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: recipe.usedIngredients.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: ExpansionTile(
                          title: const Text("Used Ingredients"),
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: recipe.usedIngredients.length,
                              itemBuilder: (context, index) {
                                return SharedListTile(recipe: recipe.usedIngredients[index]);
                              }
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: recipe.missedIngredients.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: ExpansionTile(
                          title: const Text("Missed Ingredients"),
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: recipe.missedIngredients.length,
                                itemBuilder: (context, index) {
                                  return SharedListTile(recipe: recipe.missedIngredients[index]);
                                }
                            )
                          ]
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: recipe.unusedIngredients.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: ExpansionTile(
                          title: const Text("Unused Ingredients"),
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: recipe.unusedIngredients.length,
                              itemBuilder: (context, index) {
                                return SharedListTile(recipe: recipe.unusedIngredients[index]);
                              }
                            )
                          ]
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.pop(context); },
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
    );
  }
}
