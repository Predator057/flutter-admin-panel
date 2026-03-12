import 'package:admin_service/colors.dart';
import 'package:admin_service/providers/recource_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeftTabs extends StatefulWidget {
  const LeftTabs({super.key});

  @override
  LeftTabsState createState() => LeftTabsState();
}

class LeftTabsState extends State<LeftTabs> {
  @override
  Widget build(BuildContext context) {
    return (SizedBox(
      width: 300,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(36, 182, 208, 212),
          border: BoxBorder.fromLTRB(
            right: BorderSide(
              color: const Color.fromARGB(174, 238, 238, 238),
              width: 2,
            ),
          ),
        ),

        child: Column(
          children: [
            Container(
              height: 100,
              padding: EdgeInsets.all(10),
              color: actveColor,
              child: Image.asset("assets/images/logo.png"),
            ),
            SizedBox(height: 60),
            RadioTabButton(),
          ],
        ),
      ),
    ));
  }
}

class RadioTabButton extends StatefulWidget {
  const RadioTabButton({super.key});

  @override
  RadioTabButtonState createState() => RadioTabButtonState();
}

class RadioTabButtonState extends State<RadioTabButton> {
  int group = 0;
  @override
  Widget build(BuildContext context) {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonTab(
          1,
          "Сводка",
          group,
          onClick: (id) {
            group = id;
            setState(() {});
          },
        ),
        ButtonTab(
          2,
          "Услуги",
          group,
          onClick: (id) {
            group = id;
            setState(() {});
          },
        ),
        ButtonTab(
          3,
          "Рецепты",
          group,
          onClick: (id) {
            group = id;
            setState(() {});
          },
        ),
        ButtonTab(
          4,
          "Опции",
          group,
          onClick: (id) {
            group = id;
            setState(() {});
          },
        ),
        ButtonTab(
          5,
          "Лояльность",
          group,
          onClick: (id) {
            group = id;
            setState(() {});
          },
        ),
        ButtonTab(
          6,
          "Отчеты",
          group,
          onClick: (id) {
            group = id;
            setState(() {});
          },
        ),
        ButtonTab(
          7,
          "Инструкция",
          group,
          onClick: (id) {
            group = id;
            setState(() {});
          },
        ),
        ButtonTab(
          8,
          "Конфигурация",
          group,
          onClick: (id) {
            group = id;
            setState(() {});
          },
        ),
      ],
    ));
  }
}

class ButtonTab extends ConsumerStatefulWidget {
  final int group;
  final int idResource;
  final String text;
  final void Function(int) onClick;

  const ButtonTab(
    this.idResource,
    this.text,
    this.group, {
    super.key,
    required this.onClick,
  });

  @override
  ButtonTabState createState() => ButtonTabState();
}

class ButtonTabState extends ConsumerState<ButtonTab> {
  Color normalColor = const Color.fromARGB(0, 1, 1, 1);
  Color selectedColor = const Color.fromARGB(166, 175, 175, 175);

  @override
  Widget build(BuildContext context) {
    return (Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.group == widget.idResource ? selectedColor : normalColor,
      ),
      width: 250,
      height: 50,
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          widget.onClick(widget.idResource);
          print(widget.group);
          ref.read(resourceProvider.notifier).setTab(widget.idResource);
        },
        child: Text(
          "⇒ ${widget.text}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            //fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    ));
  }
}
