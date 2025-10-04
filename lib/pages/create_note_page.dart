import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/pages/show_notes_page.dart';
import 'package:note_app/utils/app_color.dart';
import 'package:note_app/utils/app_constants.dart';
import 'package:note_app/utils/elevated_button_widget.dart';
import 'package:note_app/utils/text_field_widget.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});
  static final String id = "/create_note_page";
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
            TextFieldWidget(
              contentController: contentController,
              titleController: titleController,
            ),
            const Spacer(),
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
                  );
                }
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
