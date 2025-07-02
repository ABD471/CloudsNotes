import 'package:flutter/material.dart';

class CostumBottoun extends StatelessWidget {
  final void Function()? onPressed;
  final String Title;

  const CostumBottoun({super.key, this.onPressed, required this.Title});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 80, right: 80),
      child: MaterialButton(
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(Title),
        color: Colors.orange[300],
        shape: OutlineInputBorder(),
      ),
    );
  }
}
