import 'package:flutter/material.dart';

import '../model/recipe.dart';

class SharedListTile extends StatelessWidget {
  const SharedListTile({Key? key, required this.recipe}) : super(key: key);

  final SedIngredient recipe;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 100,
        height: 200,
        child: Image.network(
          recipe.image ?? "",
          fit: BoxFit.scaleDown,
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
      title: Text(recipe.original ?? "",
        textScaleFactor: 1.2,
      ),
      subtitle: Text("${recipe.name} ${recipe.amount} ${recipe.unitLong}"),
    );
  }
}
