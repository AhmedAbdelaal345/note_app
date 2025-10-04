import 'package:flutter/material.dart';
import 'package:note_app/utils/app_color.dart';

class TextFieldAuthWidget extends StatefulWidget {
  const TextFieldAuthWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.isPassword = false,
  });
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool? isPassword;

  @override
  State<TextFieldAuthWidget> createState() => _TextFieldAuthWidgetState();
}

class _TextFieldAuthWidgetState extends State<TextFieldAuthWidget> {
  @override
  Widget build(BuildContext context) {
    bool oscureText = widget.isPassword ?? false;
    return TextFormField(
      obscureText: widget.isPassword ?? false,
      controller: widget.controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'the feild is required';
        }
        if (widget.isPassword == true && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        if (widget.labelText == "Email" &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.labelText == "Email" ? Icons.email : Icons.lock,
          color: AppColor.hinttext,
        ),
        suffixIcon: widget.isPassword == true
            ? IconButton(
                icon: Icon(
                  widget.isPassword! ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.hinttext,
                ),
                onPressed: () {
                  setState(() {
                    oscureText = !oscureText;
                  });
                },
              )
            : null,
        hint: Text(
          widget.hintText,
          style: TextStyle(
            color: AppColor.borderColor,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.borderColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.borderColor, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.hinttext, width: 1.0),
        ),
        label: Text(
          widget.labelText,
          style: TextStyle(
            color: AppColor.hinttext,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintStyle: TextStyle(
          color: AppColor.hinttext,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }
}
