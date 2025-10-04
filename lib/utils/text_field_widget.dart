import 'package:flutter/material.dart';
import 'package:note_app/utils/app_color.dart';

class TextFieldWidget extends StatelessWidget {
 final TextEditingController contentController;
  
final  TextEditingController titleController;

  const TextFieldWidget({super.key,required this.contentController,required this.titleController});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter note title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.borderColor,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.borderColor,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.borderColor,
                    width: 1.0,
                  ),
                ),
                label: Text(
                  "Title",
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
            ),
            SizedBox(height: height / 30),

            TextField(
              controller: contentController,
              cursorColor: AppColor.hinttext,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Enter note content',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.borderColor,
                    width: 1.0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.borderColor,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColor.borderColor,
                    width: 1.0,
                  ),
                ),
                label: Text(
                  "Content",
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
            ),
      ],
    );
  }
}