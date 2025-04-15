import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/presentation/screens/dashboard/dashboard.dart';
import 'package:pos_app/widgets/custom_button.dart';
import 'package:pos_app/widgets/custom_dialogue.dart';
import 'package:pos_app/widgets/custom_switch_widget.dart';

import '../../../logic/auth_logic/auth_bloc.dart';
import '../../../../constatnts/styles.dart';
import '../../../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String route = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final FocusNode userNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool connectToServer = false;
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      userNameController.text = "adibz";
      passWordController.text = "1";
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userNameController.dispose();
    passWordController.dispose();
    userNode.dispose();
    passwordNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constarints) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is FetchingUserFromServerState || state is CheckingUserOnLocalState) {
              CustomDialog.showLoading(context, loadingText: 'Checking the user');
            } else {
              CustomDialog.hideLoading(context);
            }
            if (state is FetchedUserFromServerState) {
              connectToServer = false;
            }
            if (state is CheckedUserOnLocalState) {
              if (state.userModel != null) {
                context.goNamed(DashBoardScreen.route);
              }
            }
          },
          builder: (context, state) {
            return constarints.maxWidth < 600 ? _mobileView() : _desktopView();
          },
        );
      }),
    );
  }

  _desktopView() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: AppColors.scaffoldColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/png/appicon2.webp',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Zaad Platforms',
                    style: AppStyles.getBoldTextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: AppStyles.getMediumTextStyle(fontSize: 20),
                ),
                SizedBox(height: 24),
                SizedBox(width: 600, child: loginForm()),
                SizedBox(height: 12),
                CustomResponsiveButton(onPressed: login, text: "Login"),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connect with server',
                      style: AppStyles.getMediumTextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 10),
                    CustomSwitch(
                        activeColor: AppColors.primaryColor,
                        value: connectToServer,
                        onChanged: (v) {
                          setState(() => connectToServer = !connectToServer);
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _mobileView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/png/appicon2.webp',
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Zaad Platforms',
              style: AppStyles.getBoldTextStyle(fontSize: 20),
            ),
            SizedBox(height: 24),
            Text(
              'Login',
              style: AppStyles.getMediumTextStyle(fontSize: 14),
            ),
            SizedBox(height: 24),
            loginForm(),
            SizedBox(height: 12),
            CustomResponsiveButton(onPressed: login, text: "Login"),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Connect with server',
                  style: AppStyles.getMediumTextStyle(fontSize: 14),
                ),
                SizedBox(width: 10),
                CustomSwitch(
                    value: connectToServer,
                    onChanged: (v) {
                      setState(() => connectToServer = !connectToServer);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  login() {
    if (formKey.currentState!.validate()) {
      if (connectToServer) {
        BlocProvider.of<AuthBloc>(context).add(
          CheckUserOnServer(
            context: context,
            userName: userNameController.text,
            password: passWordController.text,
          ),
        );
      } else {
        BlocProvider.of<AuthBloc>(context).add(
          CheckUserLocal(
            userName: userNameController.text,
            password: passWordController.text,
          ),
        );
      }
    }
  }

  Widget loginForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: userNameController,
            focusNode: userNode,
            labelText: 'username',
            validator: (v) {
              if (null == v || v.isEmpty) {
                return 'Please enter username';
              }
            },
          ),
          SizedBox(height: 12),
          CustomTextField(
            validator: (v) {
              if (null == v || v.isEmpty) {
                return 'Please enter passsword';
              }
            },
            controller: passWordController,
            focusNode: passwordNode,
            obscureText: true,
            labelText: 'password',
          ),
        ],
      ),
    );
  }
}
