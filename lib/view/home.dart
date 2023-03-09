import 'package:flutter/material.dart';
import 'package:recipe_finder/keys/keys.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';

import '../constants/routes.dart';
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

  String tag = "";

  bool isLoaded = false;
  bool firstTime = true;
  bool isLoading = false;

  List<Recipe>? recipeList;

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      Future.delayed(Duration.zero, () => showAlert(context));
      firstTime = false;
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/food_background.jpg"),
            fit: BoxFit.fill
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: FlexibleHeaderDelegate(
                statusBarHeight: MediaQuery.of(context).padding.top,
                expandedHeight: 240,
                background: MutableBackground(
                  collapsedColor: Theme.of(context).primaryColor,
                  expandedWidget: Image.asset(
                    'assets/food.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showAlert(context);
                    },
                  ),
                ],
                children: [
                  FlexibleTextItem(
                    text: 'Recipe Finder',
                    collapsedStyle: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                    expandedStyle: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                    expandedAlignment: Alignment.bottomLeft,
                    collapsedAlignment: Alignment.center,
                    expandedPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isLoaded,
              replacement: SliverToBoxAdapter(
                child: Container(),
              ),
              child: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                    Recipe recipe = recipeList![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.foodRoute,  arguments: recipe);
                            },
                            child: Hero(
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
                            )
                          ),
                          subtitle: Center(
                            child: Text(recipe.title ?? "",
                              textScaleFactor: 1.2,
                              textAlign: TextAlign.center,
                            )
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: recipeList?.length
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Visibility(
              visible: !isLoading,
              replacement: const Loading(),
              child: AlertDialog(
                scrollable: true,
                content: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: tagController,
                        decoration: fieldStyle.copyWith(
                            hintText: "ingredients",
                            labelText: "ingredients"
                        ),
                        onChanged: (val) {
                          tag = val;
                        },
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

                                  setState((){
                                    isLoading = true;
                                  });

                                  recipeList = await RemoteService().getRecipes(data);

                                  setState((){
                                    isLoading = false;
                                  });

                                  if (recipeList != null) {
                                    setState(() {
                                      isLoaded = true;
                                      Navigator.pop(context);
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
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
