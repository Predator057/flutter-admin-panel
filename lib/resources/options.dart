import 'package:admin_service/colors.dart';
import 'package:admin_service/providers/options_state.dart';
import 'package:admin_service/terminal_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptionsScreen extends ConsumerStatefulWidget {
  const OptionsScreen({super.key});

  @override
  OptionsScreenState createState() => OptionsScreenState();
}

class OptionsScreenState extends ConsumerState<OptionsScreen> {
  String? season;
  @override
  Widget build(BuildContext context) {
    List<Option> options = ref.watch(optionsProvider).options;
    if (options.isEmpty) {
      ref.read(optionsProvider.notifier).initDB();
      ref.read(optionsProvider.notifier).getOptions();
    }
    return (Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: const Color.fromARGB(36, 182, 208, 212),
            child: Text(
              "Список опций:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                //fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
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
              children: [
                Header(),
                for (var opt in options) OptionRow(option: opt),
                SizedBox(height: 40),
                Button(
                  content: " 💾 Сохранить",
                  onClick: () {
                    ref.read(optionsProvider.notifier).saveState();
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

class OptionRow extends ConsumerStatefulWidget {
  final Option option;
  const OptionRow({super.key, required this.option});

  @override
  OptionRowState createState() => OptionRowState();
}

class OptionRowState extends ConsumerState<OptionRow> {
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
            width: 150,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text(widget.option.name, style: _style),
            ),
          ),
          SizedBox(
            width: 150,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text(widget.option.param, style: _style),
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
                labelText: widget.option.price.toString(),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                ref
                    .read(optionsProvider.notifier)
                    .setPrice(widget.option.param, double.parse(value));
              },
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Container(
              color: cellColor,
              child: Checkbox(
                value: widget.option.isActive,
                onChanged: (v) {
                  setState(() {
                    ref
                        .read(optionsProvider.notifier)
                        .setActive(widget.option.param, v!);
                  });
                },
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
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 150,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text("Наименование", style: _headerStyle),
            ),
          ),
          SizedBox(
            width: 150,
            height: 40,
            child: Container(
              alignment: Alignment.center,
              color: cellColor,
              child: Text("Параметр", style: _headerStyle),
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
              child: Text("вкл.", style: _headerStyle),
            ),
          ),
        ],
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
      padding: EdgeInsets.all(10),
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
