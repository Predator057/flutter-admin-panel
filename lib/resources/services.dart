import 'package:admin_service/colors.dart';
import 'package:admin_service/providers/options_state.dart';
import 'package:admin_service/providers/recipes_state.dart';
import 'package:admin_service/terminal_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ServicesScreenState createState() => ServicesScreenState();
}

class ServicesScreenState extends ConsumerState<ServicesScreen> {
  String? season;
  @override
  Widget build(BuildContext context) {
    var recipes = ref.watch(recipesProvider).recipes;
    var options = ref.watch(optionsProvider).options;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            color: actveColor,
            child: Text(
              "Услуги и выдача чеков",
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: cellColor,
                      child: Text("Рецепты:", style: _style),
                    ),
                    for (int i = 0; i < recipes.length; i += 2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RecipeButton(recipe: recipes[i], onClick: () {}),
                          SizedBox(width: 10),
                          if (i + 1 < recipes.length)
                            RecipeButton(
                              recipe: recipes[i + 1],
                              onClick: () {},
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: cellColor,
                      child: Text("Опции:", style: _style),
                    ),
                    for (int i = 0; i < options.length; i += 2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          OptionButton(option: options[i], onClick: () {}),
                          SizedBox(width: 10),
                          if (i + 1 < options.length)
                            OptionButton(
                              option: options[i + 1],
                              onClick: () {},
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecipeButton extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onClick;
  const RecipeButton({super.key, required this.recipe, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 170,
      height: 130,
      padding: EdgeInsets.all(5),
      decoration: recipe.isActive
          ? BoxDecoration(
              color: const Color.fromARGB(125, 0, 152, 223),
              border: Border.all(
                color: const Color.fromARGB(211, 255, 255, 255),
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )
          : BoxDecoration(
              color: const Color.fromARGB(126, 223, 0, 0),
              border: Border.all(
                color: const Color.fromARGB(211, 255, 255, 255),
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
      child: TextButton(
        onPressed: () => onClick(),
        child: Text('Рецепт: "${recipe.name}"', style: _headerStyle),
      ),
    ));
  }
}

class OptionButton extends StatelessWidget {
  final Option option;
  final VoidCallback onClick;
  const OptionButton({super.key, required this.option, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 170,
      height: 130,
      padding: EdgeInsets.all(5),
      decoration: option.isActive
          ? BoxDecoration(
              color: const Color.fromARGB(125, 0, 152, 223),
              border: Border.all(
                color: const Color.fromARGB(211, 255, 255, 255),
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )
          : BoxDecoration(
              color: const Color.fromARGB(126, 223, 0, 0),
              border: Border.all(
                color: const Color.fromARGB(211, 255, 255, 255),
                width: 3,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
      child: TextButton(
        onPressed: () => onClick(),
        child: Text('Опция: "${option.name}"', style: _headerStyle),
      ),
    ));
  }
}

TextStyle _style = TextStyle(fontSize: 26, color: Colors.white);
TextStyle _headerStyle = TextStyle(fontSize: 16, color: Colors.white);
