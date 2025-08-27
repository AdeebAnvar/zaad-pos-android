import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/extenstions.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/branch_model.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/create_branch.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/custom_loading.dart';

class BranchListingScreen extends StatefulWidget {
  const BranchListingScreen({super.key});
  static String route = '/branch_listing';

  @override
  State<BranchListingScreen> createState() => _BranchListingScreenState();
}

class _BranchListingScreenState extends State<BranchListingScreen> {
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllBranches();
  }

  TextEditingController searchBranchController = TextEditingController();
  FocusNode searchBranchNode = FocusNode();

  List<BranchModel> branches = [];
  List<BranchModel> filteredBranches = [];

  getAllBranches() async {
    try {
      setState(() => isLoading = true);
      final response = await ApiService.getApiData(Urls.getAllBranches);
      if (response.isSuccess) {
        branches = List<BranchModel>.from(response.responseObject['data'].map((x) {
          return BranchModel.fromJson(x);
        }));
        filteredBranches = List.from(branches); // initialize with all branches
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
    searchBranchNode.dispose();
    searchBranchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Branches',
          style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(child: CustomLoading())
          : ListView(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AutoCompleteTextField<BranchModel>(
                      items: branches,
                      focusNode: searchBranchNode,
                      displayStringFunction: (v) {
                        return v.name ?? "";
                      },
                      onChanged: (selectedBranch) {
                        if (selectedBranch.isNullOrEmpty()) {
                          filteredBranches = branches;
                          setState(() {});
                        } else {
                          setState(() {
                            filteredBranches = branches.where((branch) => branch.name!.toLowerCase() == selectedBranch.toLowerCase()).toList();
                          });
                        }
                      },
                      selectedItems: [searchBranchController.text],
                      onSelected: (selectedBranch) {
                        setState(() {
                          filteredBranches = branches.where((branch) => branch.id == selectedBranch.id).toList();
                        });
                      },
                      controller: searchBranchController,
                      labelText: 'Search Branch',
                      defaultText: "Search Branch"),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7,
                      mainAxisExtent: 80,
                      maxCrossAxisExtent: 400,
                    ),
                    itemCount: filteredBranches.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                filteredBranches[i].image ?? "",
                                headers: Urls.getHeaders(),
                                errorBuilder: (context, error, stackTrace) {
                                  print(error);
                                  return Container(
                                    height: 60,
                                    width: 60,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  filteredBranches[i].name ?? "",
                                  style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  filteredBranches[i].location ?? "",
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
        onPressed: () => context.pushNamed(CreateBranchScreen.route).then((v) {
          getAllBranches();
        }),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        label: Text(
          'Create Branch',
          style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
