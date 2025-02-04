import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/data/utils/extensions.dart';
import 'package:pos_app/logic/auth_logic/auth_bloc.dart';
import 'package:pos_app/presentation/screens/dashboard/dashboard.dart';

import '../../../../constatnts/styles.dart';
import '../../../../widgets/custom_textfield.dart';

loadingDialogue(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      });
}

customSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      content: Text(
        message,
        style: AppStyles.getRegularTextStyle(fontSize: 14, color: Colors.white),
      ),
    ),
  );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController passWordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey();
    if (kDebugMode) {
      userNameController.text = "adibz";
      passWordController.text = "1";
    }
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (c, state) {
        if (state is FetchingUserFromServerState) {
          loadingDialogue(context);
        }
        if (state is CheckingUserOnLocalState) {
          loadingDialogue(context);
        }
        if (state is CheckedUserOnLocalState) {
          context.pop();
          if (null != state.userModel) {
            context.goNamed(DashBoardScreen.route);
          } else {
            customSnackBar(context, "User not found! Please try again");
          }
        }
        if (state is FetchedUserFromServerState) {
          context.pop();
          if (!state.haveUser) {
            customSnackBar(
              context,
              "No user found on server",
            );
          } else {
            customSnackBar(
              context,
              "User found! Please log in",
            );
          }
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
                  child: Image.asset('assets/images/png/logo.png'),
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height / 1.3,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Login',
                        style: AppStyles.getSemiBoldTextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 50),
                      Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: CustomTextField(
                          controller: userNameController,
                          fillColor: Colors.white,
                          labelText: 'UserName',
                          validator: (v) {
                            if (v.isNullOrEmpty()) {
                              return "Enter username";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: CustomTextField(
                          validator: (v) {
                            if (v.isNullOrEmpty()) {
                              return "Enter password";
                            }
                            return null;
                          },
                          controller: passWordController,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          // context.goNamed(HomeScreen)
                          BlocProvider.of<AuthBloc>(context).add(
                            CheckUserLocal(userName: userNameController.text, password: passWordController.text),
                          );
                        },
                        style: AppStyles.filledButton.copyWith(
                          fixedSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.sizeOf(context).width, 60)),
                        ),
                        child: Text(
                          'Login',
                          style: AppStyles.getMediumTextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => showUserCheckDialogue(context),
                        child: Text(
                          'Have trouble in login? Connect to server.',
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

  showUserCheckDialogue(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController passWordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey();
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      'Login',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 50),
                    Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: CustomTextField(
                        controller: userNameController,
                        fillColor: Colors.white,
                        labelText: 'UserName',
                        validator: (v) {
                          if (v.isNullOrEmpty()) {
                            return "Enter username";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: CustomTextField(
                        validator: (v) {
                          if (v.isNullOrEmpty()) {
                            return "Enter password";
                          }
                          return null;
                        },
                        controller: passWordController,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        obscureText: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        c.pop();
                        BlocProvider.of<AuthBloc>(context).add(
                          CheckUserOnServer(userName: userNameController.text, password: passWordController.text),
                        );
                      },
                      style: AppStyles.filledButton.copyWith(
                        fixedSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.sizeOf(context).width, 60)),
                      ),
                      child: Text(
                        'Check',
                        style: AppStyles.getMediumTextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
