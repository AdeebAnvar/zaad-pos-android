import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../constatnts/styles.dart';
import '../../../../widgets/custom_textfield.dart';
import '../dashboard/dashboard.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController passWordController = TextEditingController();
    return Scaffold(
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
                    hint: 'UserName',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: CustomTextField(
                    controller: passWordController,
                    fillColor: Colors.white,
                    hint: 'Password',
                    obscureText: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => context.goNamed(HomeScreen.route),
                  style: AppStyles.filledButton.copyWith(
                    fixedSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.sizeOf(context).width, 60)),
                  ),
                  child: Text(
                    'Login',
                    style: AppStyles.getMediumTextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Have trouble in login? contact admin.',
                  style: AppStyles.getMediumTextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
