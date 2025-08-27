import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/extenstions.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/user_models.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/create_user_screen.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/custom_loading.dart';

class UsersAndPermissions extends StatefulWidget {
  const UsersAndPermissions({super.key});
  static String route = '/users_and_permissions';

  @override
  State<UsersAndPermissions> createState() => _UsersAndPermissionsState();
}

class _UsersAndPermissionsState extends State<UsersAndPermissions> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
  }

  TextEditingController searchUserController = TextEditingController();
  FocusNode searchUserNode = FocusNode();

  List<UserModel> userModel = [];
  List<UserModel> filtereduserModels = [];

  getAllUsers() async {
    try {
      setState(() => isLoading = true);
      final response = await ApiService.getApiData(Urls.getAllUsers);
      if (response.isSuccess) {
        userModel = List<UserModel>.from(response.responseObject['data'].map((x) {
          return UserModel.fromMap(x);
        }));
        filtereduserModels = List.from(userModel); // initialize with all branches
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users and Permissions',
          style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CustomLoading(),
            )
          : ListView(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AutoCompleteTextField<UserModel>(
                      items: userModel,
                      displayStringFunction: (v) {
                        return v.name;
                      },
                      focusNode: searchUserNode,
                      onChanged: (selectedUser) {
                        if (selectedUser.isNullOrEmpty()) {
                          filtereduserModels = userModel;
                          setState(() {});
                        } else {
                          setState(() {
                            filtereduserModels = userModel.where((user) => user.name!.toLowerCase() == selectedUser.toLowerCase()).toList();
                          });
                        }
                      },
                      selectedItems: [searchUserController.text],
                      onSelected: (selectedUser) {
                        setState(() {
                          filtereduserModels = userModel.where((user) => user.id == selectedUser.id).toList();
                        });
                      },
                      labelText: 'Search User',
                      defaultText: "Search User"),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7,
                      mainAxisExtent: 80,
                      maxCrossAxisExtent: 400,
                    ),
                    itemCount: filtereduserModels.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              child: Center(
                                child: Icon(Icons.person_2_outlined),
                              ),
                            ),
                            SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  filtereduserModels[i].name,
                                  style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  filtereduserModels[i].branchName,
                                  style: AppStyles.getMediumTextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Spacer(),
                            PopupMenuButton(
                                itemBuilder: (c) => [
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 4),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete),
                                            SizedBox(width: 4),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ])
                          ],
                        ),
                      );
                    }),
                SizedBox(height: 40),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(CreateUserScreen.route).then((v) {
          getAllUsers();
        }),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        label: Text(
          'Create User',
          style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
