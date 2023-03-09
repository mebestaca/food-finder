import '../model/recipe.dart';
import 'package:http/http.dart' as http;

class RemoteService{
  Future<List<Recipe>?> getRecipes(Map<String,String> queryParameters) async {

    final uri = Uri.https('api.spoonacular.com', '/recipes/findByIngredients', queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      return recipeFromJson(json);
    }

    return null;
  }
}