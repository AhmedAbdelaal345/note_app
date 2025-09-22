import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/utils/app_color.dart';
import 'package:note_app/utils/app_constants.dart';
import 'package:note_app/utils/text_field_widget.dart';

class NotesDetailsPage extends StatefulWidget {
  const NotesDetailsPage({super.key});

  static final String id = "/notes_details_page";

  @override
  State<NotesDetailsPage> createState() => _NotesDetailsPageState();
}

class _NotesDetailsPageState extends State<NotesDetailsPage> {
  late final TextEditingController contentController;
  late final TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    contentController = TextEditingController();
    titleController = TextEditingController();
  }

  @override
  void dispose() {
    contentController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String docId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Details Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showDialog(context, docId);
            },
            icon: const Icon(Icons.edit_note_outlined, size: 35),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(AppConstants.collectionName)
            .snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          } else if (!asyncSnapshot.hasData ||
              asyncSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notes available'));
          }
          QueryDocumentSnapshot<Map<String, dynamic>> note = asyncSnapshot
              .data!
              .docs
              .firstWhere((doc) => doc.id == docId);
          return Center(
            child: ListTile(
              title: Text(
                note[AppConstants.title],
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note[AppConstants.content],
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Created At: ${note[AppConstants.createdAt].toDate()}",
                    style: TextStyle(
                      color: AppColor.hinttext,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width*0.95,
          height: MediaQuery.of(context).size.height*0.7,
          child: AlertDialog(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height / 2,
              minWidth: MediaQuery.of(context).size.width / 1.2,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width *0.95,
            ),
            backgroundColor: AppColor.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(
              'Edit Note',
              style: TextStyle(
                color: AppColor.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: TextFieldWidget(
              contentController: contentController,
              titleController: titleController,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection(AppConstants.collectionName)
                      .doc(docId)
                      .update({
                        AppConstants.title: titleController.text,
                        AppConstants.content: contentController.text,
                      })
                      .then((_) {
                        Navigator.pop(context);
                      })
                      .catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update note: $error'),
                            duration: const Duration(milliseconds: 700),
                            backgroundColor: AppColor.red,
                          ),
                        );
                      });
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
