import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constatnts/colors.dart';
import '../../../data/utils/extensions.dart';
import '../../../logic/auth_logic/auth_bloc.dart';
import '../dashboard/dashboard.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../../constatnts/styles.dart';
import '../../../../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  static String route = '/login';

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      userNameController.text = "adibz";
      passWordController.text = "1";
    }

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is FetchingUserFromServerState || state is CheckingUserOnLocalState) {
          loadingDialogue(context);
        } else if (state is CheckedUserOnLocalState) {
          context.pop();
          state.userModel != null ? context.goNamed(DashBoardScreen.route) : CustomSnackBar.showError(message: 'User not found');
        } else if (state is FetchedUserFromServerState) {
          context.pop();
          state.status ? CustomSnackBar.showSuccess(message: "${state.message}! Please login") : CustomSnackBar.showError(message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: ListView(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 3,
                child: Center(
                    child: Image.asset(
                  'assets/images/png/appicon2.webp',
                  height: 100,
                  width: 100,
                )),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height / 1.3,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Text('Login', style: AppStyles.getSemiBoldTextStyle(fontSize: 22)),
                      const SizedBox(height: 50),
                      buildTextField(controller: userNameController, label: 'UserName'),
                      const SizedBox(height: 20),
                      buildTextField(controller: passWordController, label: 'Password', obscureText: true),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthBloc>(context).add(
                              CheckUserLocal(userName: userNameController.text, password: passWordController.text),
                            );
                          }
                        },
                        style: AppStyles.filledButton.copyWith(
                          fixedSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.sizeOf(context).width, 60)),
                        ),
                        child: Text('Login', style: AppStyles.getMediumTextStyle(fontSize: 15, color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => showUserCheckDialogue(context),
                        child: Text(
                          'Have trouble logging in? Connect to server.',
                          style: AppStyles.getMediumTextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTextField({required TextEditingController controller, required String label, bool obscureText = false}) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: CustomTextField(
        controller: controller,
        fillColor: Colors.white,
        labelText: label,
        obscureText: obscureText,
        validator: (value) => value.isNullOrEmpty() ? "Enter $label" : null,
      ),
    );
  }

  void showUserCheckDialogue(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),
              Text('Login', style: AppStyles.getSemiBoldTextStyle(fontSize: 22)),
              const SizedBox(height: 50),
              buildTextField(controller: userNameController, label: 'UserName'),
              const SizedBox(height: 20),
              buildTextField(controller: passWordController, label: 'Password', obscureText: true),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    c.pop();
                    BlocProvider.of<AuthBloc>(context).add(
                      CheckUserOnServer(context: context, userName: userNameController.text, password: passWordController.text),
                    );
                  }
                },
                style: AppStyles.filledButton.copyWith(
                  fixedSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.sizeOf(context).width, 60)),
                ),
                child: Text('Check', style: AppStyles.getMediumTextStyle(fontSize: 15, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void loadingDialogue(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (c) => AlertDialog(
      backgroundColor: Colors.transparent,
      content: const Center(child: CircularProgressIndicator(color: Colors.white)),
    ),
  );
}
