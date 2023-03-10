import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../model/recipe.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipeList = ModalRoute.of(context)?.settings.arguments as List<Recipe>;

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
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: recipeList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8
                  ),
                  child: Card(
                    child: ListTile(
                      subtitle: Text(
                        recipeList[index].title.toString(),
                        textScaleFactor: 1.2,
                        textAlign: TextAlign.center,
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.recipeDetailRoute,  arguments: recipeList[index]);
                        },
                        child: Hero(
                          tag: recipeList[index].id.toString(),
                          child: Image.network(
                            recipeList[index].image ?? "",
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
                );
              }
            )
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
