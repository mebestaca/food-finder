// To parse this JSON data, do
//
//     final recipe = recipeFromJson(jsonString);

import 'dart:convert';

List<Recipe> recipeFromJson(String str) => List<Recipe>.from(json.decode(str).map((x) => Recipe.fromJson(x)));

String recipeToJson(List<Recipe> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Recipe {
  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.imageType,
    required this.usedIngredientCount,
    required this.missedIngredientCount,
    required this.missedIngredients,
    required this.usedIngredients,
    required this.unusedIngredients,
    required this.likes,
  });

  int id;
  String title;
  String image;
  ImageType imageType;
  int usedIngredientCount;
  int missedIngredientCount;
  List<SedIngredient> missedIngredients;
  List<SedIngredient> usedIngredients;
  List<SedIngredient> unusedIngredients;
  int likes;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    imageType: imageTypeValues.map[json["imageType"]] as ImageType,
    usedIngredientCount: json["usedIngredientCount"],
    missedIngredientCount: json["missedIngredientCount"],
    missedIngredients: List<SedIngredient>.from(json["missedIngredients"].map((x) => SedIngredient.fromJson(x))),
    usedIngredients: List<SedIngredient>.from(json["usedIngredients"].map((x) => SedIngredient.fromJson(x))),
    unusedIngredients: List<SedIngredient>.from(json["unusedIngredients"].map((x) => SedIngredient.fromJson(x))),
    likes: json["likes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "imageType": imageTypeValues.reverse[imageType],
    "usedIngredientCount": usedIngredientCount,
    "missedIngredientCount": missedIngredientCount,
    "missedIngredients": List<dynamic>.from(missedIngredients.map((x) => x.toJson())),
    "usedIngredients": List<dynamic>.from(usedIngredients.map((x) => x.toJson())),
    "unusedIngredients": List<dynamic>.from(unusedIngredients.map((x) => x.toJson())),
    "likes": likes,
  };
}

enum ImageType { jpg }

final imageTypeValues = EnumValues({
  "jpg": ImageType.jpg
});

class SedIngredient {
  SedIngredient({
    required this.id,
    required this.amount,
    required this.unit,
    required this.unitLong,
    required this.unitShort,
    required this.aisle,
    required this.name,
    required this.original,
    required this.originalName,
    required this.meta,
    required this.image,
    this.extendedName,
  });

  int id;
  double amount;
  String unit;
  String unitLong;
  String unitShort;
  String aisle;
  String name;
  String original;
  String originalName;
  List<String> meta;
  String image;
  String? extendedName;

  factory SedIngredient.fromJson(Map<String, dynamic> json) => SedIngredient(
    id: json["id"],
    amount: json["amount"]?.toDouble(),
    unit: json["unit"],
    unitLong: json["unitLong"],
    unitShort: json["unitShort"],
    aisle: json["aisle"],
    name: json["name"],
    original: json["original"],
    originalName: json["originalName"],
    meta: List<String>.from(json["meta"].map((x) => x)),
    image: json["image"],
    extendedName: json["extendedName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "unit": unit,
    "unitLong": unitLong,
    "unitShort": unitShort,
    "aisle": aisle,
    "name": name,
    "original": original,
    "originalName": originalName,
    "meta": List<dynamic>.from(meta.map((x) => x)),
    "image": image,
    "extendedName": extendedName,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
