import 'package:admin_service/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String content;
  final VoidCallback onClick;
  const Button({super.key, required this.content, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return (Container(
      decoration: BoxDecoration(
        color: buttonGreen,
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(249, 255, 255, 255),
        ),
        borderRadius: BorderRadius.circular(6),
      ),

      child: TextButton(
        onPressed: () => onClick(),
        child: Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ));
  }
}

class CellButton extends StatelessWidget {
  final String content;
  final VoidCallback onClick;
  const CellButton({super.key, required this.content, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 45,
      color: buttonGreen,
      child: TextButton(
        onPressed: () => onClick(),
        child: Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ));
  }
}
