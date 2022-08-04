import 'package:al3la_recipe/core/app_theme.dart';
import 'package:flutter/material.dart';

class MessageDisplayWidget extends StatelessWidget {
  final String message;
  const MessageDisplayWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(fontSize: 20,color: defaultColor),
            textAlign: TextAlign.center,
          ),
        )),
      ),
    );
  }
}
