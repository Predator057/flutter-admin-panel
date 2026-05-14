import 'package:admin_service/colors.dart';
import 'package:admin_service/providers/api_client.dart';
import 'package:admin_service/providers/recipes_state.dart';
import 'package:admin_service/terminal_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// const List<Operation> _OPERATIONS = [
//   Operation('Мойка', 1, 0, 0),
//   Operation('Мойка x3 К', 2, 0, 0),
//   Operation('Мойка x3 Б', 3, 0, 0),
//   Operation('Мойка x3 КБ', 4, 0, 0),
//   Operation('Москитная', 5, 0, 0),
//   Operation('Моющее А', 6, 0, 0),
//   Operation('Моющее А x3 Б', 7, 0, 0),
//   Operation('Моющее А x3 КБ', 8, 0, 0),
//   Operation('Моющее А 1/2', 9, 0, 0),
//   Operation('Моющее B', 10, 0, 0),
//   Operation('Моющее B x3 Б', 11, 0, 0),
//   Operation('Моющее B x3 КБ', 12, 0, 0),
//   Operation('Моющее B 1/2', 13, 0, 0),
//   Operation('Пена', 15, 0, 0),
//   Operation('Пена x3 Б', 16, 0, 0),
//   Operation('Воск', 17, 0, 0),
//   Operation('Осмос', 18, 0, 0),
//   Operation('Воск + Осмос', 19, 0, 0),
//   Operation('Обдув', 20, 0, 0),
// ];
const List<Operation> _OPERATIONS = [
  Operation('Мойка', 1, 0, 0),
  Operation('Мойка x3 К', 2, 0, 0),
  Operation('Мойка x3 Б', 3, 0, 0),
  Operation('Мойка x3 КБ', 4, 0, 0),
  Operation('Москитная', 5, 0, 0),
  Operation('Моющее А', 6, 0, 0),
  Operation('Моющее А x3 Б', 7, 0, 0),
  Operation('Моющее А x3 КБ', 8, 0, 0),
  Operation('Моющее А 1/2', 9, 0, 0),
  Operation('Моющее B', 10, 0, 0),
  Operation('Моющее B x3 Б', 11, 0, 0),
  Operation('Моющее B x3 КБ', 12, 0, 0),
  Operation('Моющее B 1/2', 13, 0, 0),
  Operation('Пена', 15, 0, 0),
  Operation('Пена x3 Б', 16, 0, 0),
  Operation('Воск', 17, 0, 0),
  Operation('Осмос', 18, 0, 0),
  Operation('Воск + Осмос', 19, 0, 0),
  Operation('Обдув', 20, 0, 0),
];

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  RecipesScreenState createState() => RecipesScreenState();
}

class RecipesScreenState extends ConsumerState<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = ref.watch(recipesProvider).recipes;
    String season = ref.watch(configProvider).season;
    if (season == "") {
      ref.read(configProvider.notifier).getSeason();
    } else if (recipes.isEmpty) {
      ref.read(recipesProvider.notifier).initDB();
      ref.read(recipesProvider.notifier).getRecipes(season);
    }
    ref.listen(configProvider, (prev, current) {
      if (prev != null) {
        if (prev.season != current.season) {
          ref.read(recipesProvider.notifier).getRecipes(current.season);
        }
      }
    });
    return (Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: const Color.fromARGB(36, 182, 208, 212),
              child: Text(
                "Список рецептов:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  //fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            RadioGroup<String>(
              onChanged: (s) {
                if (s != null) {
                  print("выбрали сезон $s");
                  ref.read(configProvider.notifier).setSeason(s);
                }
              },
              groupValue: season,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Режим работы: ", style: _style),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ListTile(
                      title: Text("Летний", style: _style),
                      leading: Radio<String>(
                        activeColor: Colors.amber,
                        toggleable: true,
                        value: "summer",
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ListTile(
                      title: Text("Зимний", style: _style),
                      leading: Radio<String>(
                        activeColor: Colors.amber,
                        toggleable: true,
                        value: "winter",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(164, 231, 245, 255),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Header(),
                  for (var r in recipes) RecipeRow(recipe: r),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        content: " 💾 Сохранить",
                        onClick: () {
                          ref.read(recipesProvider.notifier).saveState();
                        },
                      ),
                      Button(
                        content: "Добавить ➕  ",
                        onClick: () {
                          print("Добавим");
                          ref.read(recipesProvider.notifier).addNew();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class RecipeRow extends ConsumerStatefulWidget {
  final Recipe recipe;
  const RecipeRow({super.key, required this.recipe});

  @override
  RecipeRowState createState() => RecipeRowState();
}

class RecipeRowState extends ConsumerState<RecipeRow> {
  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 45,
      color: cellColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text(widget.recipe.id.toString(), style: _style),
            ),
          ),
          SizedBox(
            width: 300,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                focusColor: Colors.white,
                labelText: widget.recipe.name,

                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                ref
                    .read(recipesProvider.notifier)
                    .setName(widget.recipe.id, value);
              },
            ),
          ),
          SizedBox(
            width: 80,
            height: 40,
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Только цифры 0-9
              ],
              decoration: InputDecoration(
                filled: true,
                focusColor: Colors.white,
                labelText: widget.recipe.price.toString(),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value != "") {
                  ref
                      .read(recipesProvider.notifier)
                      .setPrice(widget.recipe.id, double.parse(value));
                }
              },
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              color: cellColor,
              child: Checkbox(
                value: widget.recipe.isActive,
                onChanged: (v) {
                  setState(() {
                    ref
                        .read(recipesProvider.notifier)
                        .setActive(widget.recipe.id, v!);
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: backModal,
                        child: OperationWindow(widget.recipe),
                      );
                    },
                  );
                },
                child: Text("✏️"),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: InkWell(
                onTap: () {
                  ref.read(recipesProvider.notifier).remove(widget.recipe.id);
                },
                child: Text("🗑️"),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 45,
      color: header,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text("#", style: _headerStyle),
            ),
          ),
          SizedBox(
            width: 300,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text("Имя", style: _headerStyle),
            ),
          ),
          SizedBox(
            width: 80,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text("Цена", style: _headerStyle),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text("Вкл.", style: _headerStyle),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text("ред.", style: _headerStyle),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text("удл.", style: _headerStyle),
            ),
          ),
        ],
      ),
    ));
  }
}

class OperationWindow extends ConsumerStatefulWidget {
  final Recipe recipe;
  const OperationWindow(this.recipe, {super.key});

  @override
  OperationWindowsState createState() => OperationWindowsState();
}

class OperationWindowsState extends ConsumerState<OperationWindow> {
  int idOpen = -1;
  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 800,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
      //color: cellColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button(
                content: "Добавить ➕  ",
                onClick: () {
                  setState(() {
                    ref
                        .read(recipesProvider.notifier)
                        .addOperation(widget.recipe.id);
                  });
                },
              ),
              Button(content: "Применить ✔  ", onClick: () {}),
            ],
          ),
          SizedBox(height: 20),
          HeaderOperationRow(),
          SizedBox(height: 5),
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  ref
                      .read(recipesProvider.notifier)
                      .drag(oldIndex, newIndex, widget.recipe.id);
                });
              },
              children: [
                for (int i = 0; i < widget.recipe.operations.length; i++)
                  OperationRow(
                    key: ValueKey("opr = $i"),
                    i,
                    idOpen,
                    widget.recipe.id,
                    widget.recipe.operations[i],
                    onEditClick: (id) {
                      setState(() {
                        idOpen = id;
                      });
                    },
                    onDelete: () {
                      setState(() {
                        ref
                            .read(recipesProvider.notifier)
                            .removeOperations(widget.recipe.id, i);
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class OperationRow extends ConsumerStatefulWidget {
  final int id;
  final int idRecipe; //рецепт которому принадлежит этот список операций
  final Operation operation;
  final void Function(int) onEditClick;
  final VoidCallback onDelete;
  final int idOpen;

  const OperationRow(
    this.id,
    this.idOpen,
    this.idRecipe,
    this.operation, {
    super.key,
    required this.onEditClick,
    required this.onDelete,
  });
  @override
  OperationRowState createState() => OperationRowState();
}

class OperationRowState extends ConsumerState<OperationRow> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    isOpen = widget.id == widget.idOpen;
    return (Container(
      padding: EdgeInsets.fromLTRB(10, 2, 40, 2),
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.topLeft,
                  decoration: _cell,
                  child: TextButton(
                    onPressed: () {
                      isOpen
                          ? widget.onEditClick(-1)
                          : widget.onEditClick(widget.id);
                    },
                    child: Text(isOpen ? "➖" : "➗"),
                  ),
                ),
                Container(
                  width: 300,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: _cell,
                  child: Text(widget.operation.name, style: _style),
                ),
                Container(
                  width: 50,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: _cell,
                  child: Text(widget.operation.param.toString(), style: _style),
                ),
                Container(
                  width: 70,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: _cell,
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.white,
                      labelText: widget.operation.ratio.toString(),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value != "") {
                        ref
                            .read(recipesProvider.notifier)
                            .setRatio(
                              widget.idRecipe,
                              widget.id,
                              int.parse(value),
                            );
                      }
                    },
                  ),
                ),
                Container(
                  width: 70,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: _cell,
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Только цифры 0-9
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      focusColor: Colors.white,
                      labelText: widget.operation.timeout.toString(),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value != "") {
                        ref
                            .read(recipesProvider.notifier)
                            .setTimeout(
                              widget.idRecipe,
                              widget.id,
                              int.parse(value),
                            );
                      }
                    },
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: _cell,
                  child: InkWell(
                    onTap: () {
                      widget.onDelete();
                    },
                    child: Text("🗑️", style: _style),
                  ),
                ),
              ],
            ),
            if (isOpen)
              for (var o in _OPERATIONS)
                OperationNameButton(
                  o,
                  onChanged: (opr) {
                    setState(() {
                      widget.onEditClick(
                        -1,
                      ); //Закроем список(-1 = ничего не открыто)
                      ref
                          .read(recipesProvider.notifier)
                          .setOperation(widget.idRecipe, widget.id, opr);
                    });
                  },
                ),
          ],
        ),
      ),
    ));
  }
}

class HeaderOperationRow extends StatelessWidget {
  const HeaderOperationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return (Container(
      padding: EdgeInsets.fromLTRB(10, 2, 40, 2),
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: _cell,
            child: Text("выб", style: _headerStyle),
          ),
          Container(
            width: 300,
            height: 40,
            alignment: Alignment.center,
            color: cellColor,
            child: Text("наименование", style: _headerStyle),
          ),
          Container(
            width: 50,
            height: 40,
            alignment: Alignment.center,
            color: cellColor,
            child: Text("парам.", style: _headerStyle),
          ),
          Container(
            width: 70,
            height: 40,
            alignment: Alignment.center,
            color: cellColor,
            child: Text("коэфф.", style: _headerStyle),
          ),
          Container(
            width: 70,
            height: 40,
            alignment: Alignment.center,
            color: cellColor,
            child: Text("выдержка", style: _headerStyle),
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            color: cellColor,
            child: Text("удл.", style: _headerStyle),
          ),
        ],
      ),
    ));
  }
}

class OperationNameButton extends StatelessWidget {
  final Operation opr;
  final void Function(Operation) onChanged;
  const OperationNameButton(this.opr, {required this.onChanged, super.key});
  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 300,
      color: actveColor,
      child: TextButton(
        onPressed: () {
          onChanged(opr);
        },
        child: Text(opr.name, style: _style),
      ),
    ));
  }
}

class Button extends StatelessWidget {
  final String content;
  final VoidCallback onClick;
  const Button({super.key, required this.content, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return (Container(
      color: buttonGreen,
      child: TextButton(
        onPressed: () => onClick(),
        child: Text(content, style: _style),
      ),
    ));
  }
}

TextStyle _style = TextStyle(fontSize: 26, color: Colors.white);
TextStyle _headerStyle = TextStyle(fontSize: 14, color: Colors.white);
BoxDecoration _cell = BoxDecoration(
  border: Border.all(color: Colors.white70, width: 1),
  color: cellColor,
);
