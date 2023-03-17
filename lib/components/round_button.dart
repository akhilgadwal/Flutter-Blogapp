import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Roundbuttons extends StatelessWidget {
  final VoidCallback onpress;
  final String text;
  const Roundbuttons({super.key, required this.onpress, required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: Colors.deepPurple[400],
        minWidth: double.infinity,
        height: 50,
        onPressed: onpress,
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
