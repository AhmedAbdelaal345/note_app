import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/login_cubit.dart';
import 'package:note_app/cubit/login_state.dart';
import 'package:note_app/pages/create_note_page.dart';
import 'package:note_app/pages/register_page.dart';
import 'package:note_app/utils/app_color.dart';
import 'package:note_app/utils/elevated_button_widget.dart';
import 'package:note_app/utils/text_field_auth_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  final String id = "/login_page";
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(
            color: AppColor.textColor,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
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
                      'Login Page',
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
                          BlocProvider.of<LoginCubit>(context).loginUser(
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
                        BlocProvider.of<LoginCubit>(context).loginInWithGoogle();
                      },
                      width: width,
                    ),
                    SizedBox(height: height * 0.02),
                    Divider(color: AppColor.borderColor,thickness: 0.2,),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegisterPage.id);
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: AppColor.buttonColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
