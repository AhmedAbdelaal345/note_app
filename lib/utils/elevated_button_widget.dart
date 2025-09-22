import 'package:flutter/material.dart';
import 'package:note_app/utils/app_color.dart';

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.color,
    required this.height,
    required this.width,
    required this.text,
    required this.onPressed,
  });
  final Color color;
  final double height;
  final double width;
  final String text;
   final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(color),
        minimumSize: WidgetStatePropertyAll(
          Size(double.infinity, height / 13),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      onPressed:onPressed ,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColor.textColor,
        ),
      ),
    );
  }
}
