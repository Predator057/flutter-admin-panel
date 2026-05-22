import 'package:admin_service/colors.dart';
import 'package:admin_service/terminal_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LoyaltyScreen extends ConsumerStatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  LoyaltyScreenState createState() => LoyaltyScreenState();
}

class LoyaltyScreenState extends ConsumerState<LoyaltyScreen> {
  @override
  Widget build(BuildContext context) {
    return (Expanded(
      child: Column(
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            color: actveColor,
            child: Text(
              "Скидки и чеки",
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 40),
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
              children: [Text("Установка ночных скидок", style: _style)],
            ),
          ),
        ],
      ),
    ));
  }
}

class RecipeDiscountRow extends ConsumerStatefulWidget {
  final Recipe recipe;

  const RecipeDiscountRow(this.recipe, {super.key});
  @override
  RecipeDiscountRowState createState() => RecipeDiscountRowState();
}

class RecipeDiscountRowState extends ConsumerState<RecipeDiscountRow> {
  @override
  Widget build(BuildContext context) {
    return (Container(
      height: 45,
      color: cellColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [],
      ),
    ));
  }
}

TextStyle _style = TextStyle(fontSize: 26, color: Colors.white);
