import 'package:flutter/material.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.size,
    required this.buttonType,
    required this.myCallBack,
  }) : super(key: key);

  final Size size;
  final String buttonType;
  final VoidCallback myCallBack;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: myCallBack,
      child: Container(
        width: size.width * 0.35,
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.015,
          horizontal: size.width * 0.02,
        ),
        decoration: BoxDecoration(
          gradient: myLinearGradient,
          borderRadius: BorderRadius.circular(size.width * 0.1),
        ),
        child: Text(
          '$buttonType',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: size.width * 0.06,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
