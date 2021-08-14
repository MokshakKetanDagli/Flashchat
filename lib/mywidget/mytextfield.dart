import 'package:flutter/material.dart';
import 'package:flash_chat_app/constants.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.size,
    required this.textField,
  }) : super(key: key);

  final Size size;
  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.08,
      padding: EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.width * 0.1),
        gradient: myLinearGradient,
        color: Colors.red,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(size.width * 0.1),
        ),
        child: textField,
      ),
    );
  }
}
