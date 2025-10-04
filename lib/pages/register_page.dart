import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/login_state.dart';
import 'package:note_app/cubit/register_cubit.dart';
import 'package:note_app/pages/create_note_page.dart';
import 'package:note_app/utils/app_color.dart';
import 'package:note_app/utils/elevated_button_widget.dart';
import 'package:note_app/utils/text_field_auth_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  static const String id = "/register_page";
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Page',
          style: TextStyle(
            color: AppColor.textColor,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<RegisterCubit, LoginState>(
        listener: (context, state) {
          if (state is ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColor.red,
              ),
            );
          }
          if (state is SucessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Login Sucess"),
                backgroundColor: AppColor.green,
              ),
            );
            Navigator.pushReplacementNamed(context, CreateNotePage.id);
          }
          if (state is LoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Loading..."),
                backgroundColor: AppColor.blue,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: height * 0.1),
                    Text(
                      'Register Page',
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    TextFieldAuthWidget(
                      controller: emailController,
                      hintText: "Enter your Email",
                      labelText: "Email",
                    ),
                    SizedBox(height: height * 0.02),
                    TextFieldAuthWidget(
                      controller: passwordController,
                      hintText: "Enter your Password",
                      labelText: "Password",
                      isPassword: true,
                    ),
                    SizedBox(height: height * 0.05),
                    ElevatedButtonWidget(
                      color: AppColor.buttonColor,
                      height: height,
                      width: width,
                      text: "Submit",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<RegisterCubit>(context).userRegister(
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    ElevatedButtonWidget(
                      color: AppColor.whiteColor,
                      height: height,
                      text: "Sign up With Google",
                      onPressed: () {
                        BlocProvider.of<RegisterCubit>(
                          context,
                        ).registerInWithGoogle();
                      },
                      width: width,
                    ),
                    SizedBox(height: height * 0.02),
                    Divider(color: AppColor.borderColor, height: height * 0.05),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: AppColor.buttonColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
