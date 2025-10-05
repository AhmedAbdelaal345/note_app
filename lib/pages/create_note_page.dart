import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/manager/create_note_cubit/create_note_cubit.dart';
import 'package:note_app/manager/create_note_cubit/create_note_state.dart';
import 'package:note_app/pages/show_notes_page.dart';
import 'package:note_app/utils/app_color.dart';
import 'package:note_app/utils/elevated_button_widget.dart';
import 'package:note_app/utils/text_field_widget.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});
  static final String id = "/create_note_page";

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset the cubit state when the page loads
    Future.microtask(() {
      context.read<CreateNoteCubit>().resetState();
    });
  }

  @override
  void dispose() {
    contentController.dispose();
    titleController.dispose();
    context.read<CreateNoteCubit>().resetState();
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
      body: BlocConsumer<CreateNoteCubit, CreateNoteState>(
        listener: (context, state) {
          if (state is ErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColor.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
          if (state is LoadingState) {
            Fluttertoast.showToast(
              msg: "Loading....",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColor.blue,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
          if (state is SuccessState) {
            Fluttertoast.showToast(
              msg: "Note saved successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        builder: (context, state) {
          if (state is ErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.error,
                    style: TextStyle(
                      color: AppColor.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CreateNoteCubit>().emit(InitState());
                    },
                    child: Text("Try Again"),
                  ),
                ],
              ),
            );
          }

          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.hinttext),
            );
          }

          return Padding(
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

                    final uid = ModalRoute.of(
                      context,
                    )!.settings.arguments.toString();
                    context.read<CreateNoteCubit>().addTodos(
                      uid,
                      title,
                      content,
                    );

                    titleController.clear();
                    contentController.clear();
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButtonWidget(
                  color: AppColor.whiteColor,
                  height: height,
                  width: width,
                  text: "Show All Notes",
                  onPressed: () {
                    final uid = ModalRoute.of(
                      context,
                    )!.settings.arguments.toString();
                    Navigator.pushNamed(
                      context,
                      ShowNotesPage.id,
                      arguments: uid,
                    );
                  },
                ),
                SizedBox(height: height / 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
