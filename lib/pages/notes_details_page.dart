import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/utils/app_color.dart';
import 'package:note_app/utils/app_constants.dart';

class NotesDetailsPage extends StatelessWidget {
  const NotesDetailsPage({super.key});

  static final String id = "/notes_details_page";
  @override
  Widget build(BuildContext context) {
    final String docId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Details Page'),
        centerTitle: true,
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
                  Text(note[AppConstants.content],style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),),
                  const SizedBox(height: 20,),
                  Text("Created At: ${note[AppConstants.createdAt].toDate()}",style: TextStyle(
                    color: AppColor.hinttext,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
