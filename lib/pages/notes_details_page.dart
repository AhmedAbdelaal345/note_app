import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/manager/create_note_cubit/create_note_cubit.dart';
import 'package:note_app/manager/create_note_cubit/create_note_state.dart';
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
    final args = ModalRoute.of(context)!.settings.arguments as List<String>;
    final String docId = args[0];
    final String uid = args[1];

    return BlocProvider(
      create: (context) => CreateNoteCubit()..getNoteDetails(uid, docId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notes Details Page'),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    _showDialog(context, docId, uid);
                  },
                  icon: const Icon(Icons.edit_note_outlined, size: 35),
                );
              },
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: Builder(
          builder: (context) {
            final cubit = context.read<CreateNoteCubit>();

            return BlocConsumer<CreateNoteCubit, CreateNoteState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  Fluttertoast.showToast(
                    msg: state.error,
                    fontSize: 16,
                    gravity: ToastGravity.BOTTOM,
                    textColor: AppColor.whiteColor,
                    backgroundColor: AppColor.red,
                  );
                }
              },
              builder: (context, state) {
                if (state is LoadingState) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.hinttext),
                  );
                }

                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: cubit.noteDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColor.hinttext,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: AppColor.red, fontSize: 16),
                        ),
                      );
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                        child: Text(
                          'Note not found',
                          style: TextStyle(
                            color: AppColor.hinttext,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    Map<String, dynamic> note = snapshot.data!.data()!;

                    // املأ الـ controllers بالبيانات الحالية
                    if (titleController.text.isEmpty) {
                      titleController.text = note[AppConstants.title] ?? '';
                      contentController.text = note[AppConstants.content] ?? '';
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note[AppConstants.title] ?? 'Untitled',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            note[AppConstants.content] ?? 'No content',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 30),
                          if (note[AppConstants.createdAt] != null)
                            Text(
                              "Created At: ${(note[AppConstants.createdAt] as Timestamp).toDate()}",
                              style: TextStyle(
                                color: AppColor.hinttext,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String docId, String uid) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
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
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFieldWidget(
              contentController: contentController,
              titleController: titleController,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
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
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection(AppConstants.users)
                      .doc(uid)
                      .collection(AppConstants.collectionName)
                      .doc(docId)
                      .update({
                        AppConstants.title: titleController.text,
                        AppConstants.content: contentController.text,
                      });

                  Navigator.pop(dialogContext);

                  // أعد تحميل البيانات
                  context.read<CreateNoteCubit>().getNoteDetails(uid, docId);
                  setState(() {});

                  Fluttertoast.showToast(
                    msg: "Note updated successfully",
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                } catch (error) {
                  Navigator.pop(dialogContext);
                  Fluttertoast.showToast(
                    msg: 'Failed to update note: $error',
                    backgroundColor: AppColor.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
