import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/utils/extensions.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/custom_button.dart';
import 'package:pos_app/widgets/custom_dialogue.dart';
import 'package:pos_app/widgets/custom_loading.dart';
import 'package:pos_app/widgets/custom_textfield.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  static String route = '/categories_screen';

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAllCategorys();
  }

  TextEditingController searchCategoryController = TextEditingController();

  FocusNode searchCategoryNode = FocusNode();

  List<CategoryModel> items = [];

  List<CategoryModel> filteredCategorys = [];

  getAllCategorys() async {
    try {
      setState(() => isLoading = true);
      final response = await ApiService.getApiData(Urls.getAllCategories);
      if (response.isSuccess) {
        items = List<CategoryModel>.from(response.responseObject['data'].map((x) {
          return CategoryModel.fromJson(x);
        }));
        filteredCategorys = List.from(items); // initialize with all branches
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
    searchCategoryNode.dispose();
    searchCategoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
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
                  child: AutoCompleteTextField<CategoryModel>(
                      items: items,
                      focusNode: searchCategoryNode,
                      displayStringFunction: (v) {
                        return v.categoryNameEng ?? "";
                      },
                      onChanged: (selectedCategory) {
                        if (selectedCategory.isNullOrEmpty()) {
                          filteredCategorys = items;
                          setState(() {});
                        } else {
                          setState(() {
                            filteredCategorys = items.where((item) => item.categoryNameEng!.toLowerCase() == selectedCategory.toLowerCase()).toList();
                          });
                        }
                      },
                      selectedItems: [searchCategoryController.text],
                      onSelected: (selectedCategory) {
                        setState(() {
                          filteredCategorys = items.where((item) => item.id == selectedCategory.id).toList();
                        });
                      },
                      controller: searchCategoryController,
                      labelText: 'Search Category',
                      defaultText: "Search Category"),
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
                    itemCount: filteredCategorys.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  filteredCategorys[i].categoryNameEng ?? "",
                                  style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  filteredCategorys[i].categoryNameArabic.toString() ?? "",
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
        onPressed: () {
          TextEditingController categoryNameController = TextEditingController();
          TextEditingController otherCategoryNameController = TextEditingController();
          GlobalKey<FormState> formKey = GlobalKey();
          CustomDialog.showResponsiveDialog(
              context,
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: categoryNameController,
                      labelText: 'Category name',
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: otherCategoryNameController,
                      labelText: 'Other category name',
                    ),
                    SizedBox(height: 8),
                    CustomResponsiveButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              CustomDialog.showLoading(context, loadingText: "Creating Category");
                              CategoryModel categoryModel = CategoryModel(
                                id: 0,
                                categoryNameEng: categoryNameController.text,
                                categoryNameArabic: otherCategoryNameController.text,
                              );
                              var response = await ApiService.postApiData(Urls.createCategory, categoryModel.toJson());
                              print(response);
                              if (response.isSuccess) {
                                context.pop();
                              }
                            } catch (e) {
                              print(e);
                            } finally {
                              CustomDialog.hideLoading(context);
                              // context.pop();
                              getAllCategorys();
                            }
                          }
                        },
                        text: 'Create')
                  ],
                ),
              ));
        },
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        label: Text(
          'Create Category',
          style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
