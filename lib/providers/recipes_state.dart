import 'package:http/http.dart' as http;
import 'package:admin_service/terminal_types.dart';
import 'package:admin_service/ipadress.dart';
import 'package:riverpod/legacy.dart';
import 'dart:convert';

class RecipesState {
  final List<Recipe> recipes;
  final String currentSeason;
  const RecipesState({this.recipes = const [], this.currentSeason = ""});

  RecipesState copyWith({List<Recipe>? recipes, String? currentSeason}) {
    return RecipesState(
      recipes: recipes ?? this.recipes,
      currentSeason: currentSeason ?? this.currentSeason,
    );
  }
}

class RecipesNotifier extends StateNotifier<RecipesState> {
  RecipesNotifier() : super(const RecipesState());
  void initDB() async {
    try {
      var response = await http.get(Uri.http('$ipback:3030', '/api/recipe'),
        headers: {
        'Authorization': 'Bearer $apiToken',
      },);
      if (response.statusCode == 200) {
        print("инициализируем рецепты");
      }
    } catch (e) {
      print("Ошибка инициализации рецептов: $e");
    }
  }

  void getRecipes(String season) async {
    try {
      var response = await http.get(
        Uri.http('$ipback:3030', '/api/get/recipes/$season'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      if (response.statusCode == 200) {
        print("Получены $season рецепты  ${response.body}");
        Map<String, dynamic> jsonData = json.decode(response.body);
        final List<Recipe> newRecipes = [];
        if (jsonData.containsKey("recepts") && jsonData["recepts"] is List) {
          for (dynamic r in jsonData["recepts"]) {
            if (r is Map<String, dynamic>) {
              newRecipes.add(
                Recipe(
                  r["id"] as int? ?? 0,
                  (r["price"] as num?)?.toDouble() ?? 0,
                  r["name"] as String? ?? '',
                  r["is_active"] as bool? ?? false,
                  _toOperationFromJson(r['operations'] ?? []),
                ),
              );
            }
          }
        }
        state = state.copyWith(recipes: newRecipes);
      } else {
        print("Ошибка рецептов ${response.statusCode}");
      }
    } catch (e) {
      print("Ошибка получения рецептов: $e");
    }
  }

  void setSeason(String season) async {
    try {
      var response = await http.patch(
        Uri.http('$ipback:3030', '/api/config/patch/season=$season'),
        headers: {
          'Authorization': 'Bearer $apiToken',
        },
      );
      print("сохраним = ${jsonEncode(state.recipes)}");
      if (response.statusCode == 200) {
        print("сохранили сезон");
      } else {
        print("Ошибка сохранения на сервере ${response.statusCode}");
      }
    } catch (e) {
      print("Не удалось сохранить $e");
    }
  }

  void addNew() {
    List<Recipe> temp = List.empty(growable: true);
    if (state.recipes.isEmpty) {
      temp.add(Recipe(1, 0, "Новый", false, []));
    } else {
      temp = state.recipes;
      temp.add(Recipe(temp.length + 1, 0, "Новый", false, []));
    }
    print("Добавим рецепт");
    state = state.copyWith(recipes: temp);
  }

  void addOperation(int idRecipe) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (r.id == idRecipe) {
        r.operations.add(Operation('мойка', 1, 0, 0));
        state = state.copyWith(recipes: recipes);
      }
    }
  }

  void setOperation(int idRecipe, int idOpr, Operation opr) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (r.id == idRecipe) {
        r.operations[idOpr] = opr;
        state = state.copyWith(recipes: recipes);
      }
    }
  }

  void setTimeout(int idRecipe, int idOpr, int timeout) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (r.id == idRecipe) {
        var opr = Operation(
          r.operations[idOpr].name,
          r.operations[idOpr].param,
          r.operations[idOpr].ratio,
          timeout,
        );
        r.operations[idOpr] = opr;
        state = state.copyWith(recipes: recipes);
      }
    }
  }

  void setRatio(int idRecipe, int idOpr, int ratio) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (r.id == idRecipe) {
        var opr = Operation(
          r.operations[idOpr].name,
          r.operations[idOpr].param,
          ratio,
          r.operations[idOpr].timeout,
        );
        r.operations[idOpr] = opr;
        state = state.copyWith(recipes: recipes);
      }
    }
  }

  void remove(int id) {
    List<Recipe> recipes = state.recipes;
    recipes.removeAt(id - 1);
    for (int i = 0; i < recipes.length; i++) {
      recipes[i].id = i + 1;
    }
    state = state.copyWith(recipes: recipes);
  }

  void removeOperations(int idRecipe, int id) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (idRecipe == r.id) {
        r.operations.removeAt(id);
        state = state.copyWith(recipes: recipes);
      }
    }
  }

  void setPrice(int id, double price) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (r.id == id) {
        r.price = price;
        state.copyWith(recipes: recipes);
        print("новое сост. ${state.recipes}");
      }
    }
  }

  void setName(int id, String name) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (r.id == id) {
        r.name = name;
        state.copyWith(recipes: recipes);
      }
    }
  }

  void setActive(int id, bool active) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (r.id == id) {
        r.isActive = active;
        state.copyWith(recipes: recipes);
      }
    }
  }

  void saveState() async {
    try {
      var response = await http.put(
        Uri.http('$ipback:3030', '/api/put/recipes/confirm'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiToken',},
        body: jsonEncode(state.recipes),
      );
      print("сохраним = ${jsonEncode(state.recipes)}");
      if (response.statusCode == 200) {
        print("сохранили");
      } else {
        print("Ошибка сохранения на сервере ${response.statusCode}");
      }
    } catch (e) {
      print("Не удалось сохранить $e");
    }
  }

  void drag(int oldIndex, int newIndex, int idRecipe) {
    List<Recipe> recipes = state.recipes;
    for (var r in recipes) {
      if (r.id == idRecipe) {
        List<Operation> operations = r.operations;
        var temp = operations.removeAt(oldIndex);
        if (r.operations.length < 3) {
          newIndex -= 1;
        }
        operations.insert(newIndex, temp);
        r.operations = operations;
        state = state.copyWith(recipes: recipes);
      }
    }
  }

  List<Operation> _toOperationFromJson(dynamic data) {
    List<Operation> temp = [];
    for (var o in data) {
      temp.add(
        Operation(
          o["name"] as String,
          o["param"] as int,
          o["ratio"] as int,
          o["timeout"] as int,
        ),
      );
    }
    return (temp);
  }
}

final recipesProvider = StateNotifierProvider<RecipesNotifier, RecipesState>(
  (ref) => RecipesNotifier(),
);
