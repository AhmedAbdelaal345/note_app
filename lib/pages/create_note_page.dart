import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/pages/show_notes_page.dart';
import 'package:note_app/utils/app_color.dart';
import 'package:note_app/utils/app_constants.dart';
import 'package:note_app/utils/elevated_button_widget.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Note',
          style: TextStyle(
            color: AppColor.textColor,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Title field
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

            const Spacer(),

            // Save Note button
            ElevatedButtonWidget(
              color: AppColor.buttonColor,
              height: height,
              width: width,
              text: "Save Note",
              onPressed: () {
                String title = titleController.text.trim();
                String content = contentController.text.trim();
                try {
                  if (title.isEmpty || content.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Title and content can't be empty!",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );

                    return;
                  }

                  FirebaseFirestore.instance
                      .collection(AppConstants.collectionName)
                      .doc()
                      .set({
                        AppConstants.title: titleController.text,
                        AppConstants.content: contentController.text,
                        AppConstants.createdAt: FieldValue.serverTimestamp(),
                        AppConstants.uid: FirebaseFirestore.instance
                            .collection(AppConstants.collectionName)
                            .doc()
                            .id,
                      });
                  titleController.clear();
                  contentController.clear();
                  Fluttertoast.showToast(
                    msg: "Note saved successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } on FirebaseException catch (e) {
Fluttertoast.showToast(
                    msg: "Failed to save note: ${e.message}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } catch (e) {
Fluttertoast.showToast(
                    msg: "An unexpected error occurred:$e",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );}
              },
            ),
            const SizedBox(height: 15),

            ElevatedButtonWidget(
              color: AppColor.whiteColor,
              height: height,
              width: width,
              text: "Show All Notes",
              onPressed: () {
                Navigator.pushNamed(context, ShowNotesPage.id);
                print("Navigate to All Notes Page");
              },
            ),
            SizedBox(height: height / 15),
          ],
        ),
      ),
    );
  }
}
