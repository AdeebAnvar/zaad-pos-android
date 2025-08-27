import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/branch_model.dart';
import 'package:pos_app/data/models/user_models.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/custom_button.dart';
import 'package:pos_app/widgets/custom_dialogue.dart';
import 'package:pos_app/widgets/custom_loading.dart';
import 'package:pos_app/widgets/custom_textfield.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});
  static String route = '/create_user';

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  bool isLoading = false;
  FocusNode userTypeFocus = FocusNode();
  FocusNode branchFocus = FocusNode();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  int? selectedUserType;
  BranchModel? selectedBranch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBranches();
  }

  List<BranchModel> branches = [];

  getAllBranches() async {
    try {
      setState(() => isLoading = true);
      final response = await ApiService.getApiData(Urls.getAllBranches);
      if (response.isSuccess) {
        branches = List<BranchModel>.from(response.responseObject['data'].map((x) {
          return BranchModel.fromJson(x);
        }));
        branches = List.from(branches); // initialize with all branches
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userTypeFocus.dispose();
    branchFocus.dispose();
    userNameController.dispose();
    passwordController.dispose();
    userTypeController.dispose();
    branchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create User',
          style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 600;
          final double fieldWidth = isWide ? (constraints.maxWidth / 2) - 24 : constraints.maxWidth;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.start,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: CustomTextField(controller: userNameController, labelText: 'User Name'),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CustomTextField(controller: passwordController, labelText: 'Password'),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: AutoCompleteTextField<UserType>(
                      items: UserType.values,
                      focusNode: userTypeFocus,
                      controller: userTypeController,
                      selectedItems: [userTypeController.text],
                      displayStringFunction: (v) => v.name ?? "",
                      onSelected: (v) {
                        selectedUserType = v.value;
                      },
                      defaultText: "branch",
                      labelText: 'Select branch',
                    ),
                  ),
                  isLoading
                      ? CustomLoading()
                      : SizedBox(
                          width: fieldWidth,
                          child: AutoCompleteTextField<BranchModel>(
                            items: branches,
                            focusNode: branchFocus,
                            controller: branchController,
                            selectedItems: [branchController.text],
                            displayStringFunction: (v) => v.name ?? "",
                            onSelected: (v) {
                              selectedBranch = v;
                            },
                            defaultText: "branch",
                            labelText: 'Select branch',
                          ),
                        ),
                  SizedBox(
                    width: isWide ? fieldWidth : constraints.maxWidth,
                    child: Align(
                      alignment: isWide ? Alignment.centerRight : Alignment.center,
                      child: CustomResponsiveButton(
                        onPressed: () async {
                          if (userNameController.text.isEmpty || passwordController.text.isEmpty || selectedUserType == null || selectedBranch == null) {
                            // Show validation message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please fill all the fields')),
                            );
                            return;
                          }
                          try {
                            CustomDialog.showLoading(context, loadingText: "Creating User");
                            print(selectedUserType);
                            UserModel userModel = UserModel(
                                id: 0,
                                password: passwordController.text,
                                branchId: selectedBranch!.id ?? 0,
                                branchName: selectedBranch!.name ?? "",
                                type: selectedUserType ?? 0,
                                name: userNameController.text);
                            var response = await ApiService.postApiData(Urls.createUser, userModel.toMap());
                            print(response);
                            if (response.isSuccess) {
                              context.pop();
                            }
                          } catch (e) {
                            print(e);
                          } finally {
                            CustomDialog.hideLoading(context);
                          }
                        },
                        text: 'Submit',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
