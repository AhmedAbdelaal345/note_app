import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/pages/notes_details_page.dart';
import 'package:note_app/utils/app_color.dart' show AppColor;

class ShowNotesPage extends StatelessWidget {
  const ShowNotesPage({super.key});
  static final String id = "show_notes_page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .snapshots()
            .map((snapshot) => snapshot.docs),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Center(
                child: Text(
                  'An error occurred',
                  style: TextStyle(
                    color: AppColor.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Center(
                child: Text(
                  'No notes available',
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          } else {
            final notes = snapshot.data;
            return ListView.builder(
              reverse: false,
              shrinkWrap: true,
              itemCount: notes!.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      NotesDetailsPage.id,
                      arguments: note.id,
                    );
                  },
                  child: ListTile(
                    title: Text(
                      note['title'] ?? 'Untitled',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColor.textColor,
                      ),
                    ),
                    subtitle: Text(
                      note['content'] ?? 'No content',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColor.hinttext,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        try {
                          FirebaseFirestore.instance
                              .collection("notes")
                              .doc(note.id)
                              .delete();
                          Fluttertoast.showToast(
                            msg: "Note deleted successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          
                        } on FirebaseException catch (e) {
                          Fluttertoast.showToast(
                            msg: "Failed to delete note: ${e.message}",
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
                      icon: const Icon(Icons.delete, color: AppColor.textColor),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
