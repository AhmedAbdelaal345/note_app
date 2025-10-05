import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/manager/create_note_cubit/create_note_cubit.dart';
import 'package:note_app/pages/notes_details_page.dart';
import 'package:note_app/utils/app_color.dart' show AppColor;

class ShowNotesPage extends StatefulWidget {
  const ShowNotesPage({super.key});
  static final String id = "show_notes_page";

  @override
  State<ShowNotesPage> createState() => _ShowNotesPageState();
}

class _ShowNotesPageState extends State<ShowNotesPage> {
  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)!.settings.arguments.toString();

    return BlocProvider(
      create: (context) => CreateNoteCubit()..getTodos(uid),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Show Notes Page',
            style: TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            final cubit = context.read<CreateNoteCubit>();

            return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: cubit.todos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColor.hinttext),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            color: AppColor.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Go Back"),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No notes found',
                      style: TextStyle(color: AppColor.hinttext, fontSize: 16),
                    ),
                  );
                }

                final notes = snapshot.data!.docs;

                return RefreshIndicator(
                  onRefresh: () async {
                    cubit.getTodos(uid);
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final noteData = note.data();

                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NotesDetailsPage.id,
                            arguments: [note.id, uid],
                          );
                        },
                        child: ListTile(
                          title: Text(
                            noteData['title'] ?? 'Untitled',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: AppColor.textColor,
                            ),
                          ),
                          subtitle: Text(
                            noteData['content'] ?? 'No content',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColor.hinttext,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(uid)
                                    .collection("notes")
                                    .doc(note.id)
                                    .delete();

                                Fluttertoast.showToast(
                                  msg: "Note deleted successfully",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                );

                                // Refresh the list
                                cubit.getTodos(uid);
                                setState(() {});
                              } on FirebaseException catch (e) {
                                Fluttertoast.showToast(
                                  msg: "Failed to delete note: ${e.message}",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: "An unexpected error occurred: $e",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: AppColor.textColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
