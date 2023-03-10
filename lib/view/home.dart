import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../keys/keys.dart';
import '../model/recipe.dart';
import '../services/remote.dart';
import '../shared/sharedDecoration.dart';
import '../shared/sharedLoading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<String> tagList = [];
  final tagController = TextEditingController();
  List<Recipe>? recipeList;
  String tag = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
            Visibility(
              visible: isLoading,
              replacement: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(
                              "assets/meal-compiler-splash.png"
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: tagController,
                              onChanged: (val) {
                                tag = val;
                              },
                              decoration: fieldStyle.copyWith(
                                  hintText: "ingredients",
                                  labelText: "ingredients"
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (tag.isNotEmpty) {
                                            tagList.add(tag);
                                            tagList = tagList.toSet().toList();
                                            FocusScope.of(context).unfocus();
                                            tagController.clear();
                                          }
                                        });
                                      },
                                      child: const Text("Add"),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {

                                        Map<String, String> data = {
                                          "ingredients" : tagList.toString(),
                                          "apiKey" : apiKey,
                                          "number" : "100"
                                        };

                                        setState(() {
                                          isLoading = true;
                                        });

                                        recipeList = await RemoteService().getRecipes(data);

                                        setState(() {
                                          isLoading = false;
                                        });

                                        if (recipeList != null) {
                                          setState(() {
                                            Navigator.pushNamed(context, Routes.recipeListRoute,
                                                arguments: recipeList
                                            );
                                          });
                                        }
                                      },
                                      child: const Text("Search"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: tagList.isNotEmpty,
                            child: const Divider(
                              height: 2,
                              thickness: 2,
                            ),
                          ),
                          Visibility(
                            visible: tagList.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Wrap(
                                children: tagList.map((e) {
                                  return Chip(
                                    label: Text(e),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () {
                                      setState(() {
                                        tagList.removeWhere((element) => element == e);
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              child: const Loading(),
            ),
          ],
        ),
      ),
    );
  }
}
