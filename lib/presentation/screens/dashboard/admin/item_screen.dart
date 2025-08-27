import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/branch_model.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/data/models/response_model.dart';
import 'package:pos_app/data/utils/extensions.dart';
import 'package:pos_app/presentation/screens/dashboard/admin/create_item.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/create_branch.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/custom_button.dart';
import 'package:pos_app/widgets/custom_dialogue.dart';
import 'package:pos_app/widgets/custom_loading.dart';
import 'package:pos_app/widgets/custom_textfield.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});
  static String route = '/items_screen';

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  bool isLoading = false;
  List<CategoryModel> categories = [];
  ProductModel productModel = ProductModel(
    addIngredient: 0,
    hiddenInPos: 0,
    id: 0,
    stockApplicable: 0,
  );
  @override
  void initState() {
    super.initState();
    getAllItems();
    getAllCategorys();
  }

  getAllCategorys() async {
    try {
      setState(() => isLoading = true);
      final response = await ApiService.getApiData(Urls.getAllCategories);
      if (response.isSuccess) {
        categories = List<CategoryModel>.from(response.responseObject['data'].map((x) {
          return CategoryModel.fromJson(x);
        }));
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  TextEditingController searchItemController = TextEditingController();
  FocusNode searchItemNode = FocusNode();

  List<ProductModel> items = [];
  List<ProductModel> filteredItems = [];

  getAllItems() async {
    try {
      setState(() => isLoading = true);
      final response = await ApiService.getApiData(Urls.getAllProducts);
      if (response.isSuccess) {
        items = List<ProductModel>.from(response.responseObject['data'].map((x) {
          return ProductModel.fromJson(x);
        }));
        filteredItems = List.from(items); // initialize with all branches
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
    searchItemNode.dispose();
    searchItemController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
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
                  child: AutoCompleteTextField<ProductModel>(
                      items: items,
                      focusNode: searchItemNode,
                      displayStringFunction: (v) {
                        return v.name ?? "";
                      },
                      onChanged: (selectedItem) {
                        if (selectedItem.isNullOrEmpty()) {
                          filteredItems = items;
                          setState(() {});
                        } else {
                          setState(() {
                            filteredItems = items.where((item) => item.name!.toLowerCase() == selectedItem.toLowerCase()).toList();
                          });
                        }
                      },
                      selectedItems: [searchItemController.text],
                      onSelected: (selectedItem) {
                        setState(() {
                          filteredItems = items.where((item) => item.id == selectedItem.id).toList();
                        });
                      },
                      controller: searchItemController,
                      labelText: 'Search Item',
                      defaultText: "Search Item"),
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
                    itemCount: filteredItems.length,
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
                                filteredItems[i].image ?? "",
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
                                  filteredItems[i].name ?? "",
                                  style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  filteredItems[i].unitPrice.toString() ?? "",
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
          GlobalKey<FormState> formKey = GlobalKey();
          bool isLoading = false;

          String? logoFilePath;
          TextEditingController itemTypeController = TextEditingController();
          FocusNode itemTypeFocus = FocusNode();

          TextEditingController categoryController = TextEditingController();
          FocusNode categoryFocus = FocusNode();

          TextEditingController unitController = TextEditingController();
          FocusNode unitFocus = FocusNode();

          TextEditingController minimumStockQuantityController = TextEditingController();
          FocusNode minimumStockQuantityFocus = FocusNode();

          TextEditingController itemNameController = TextEditingController();
          FocusNode itemNameFocus = FocusNode();

          TextEditingController itemOtherNameController = TextEditingController();
          FocusNode itemOtherNameFocus = FocusNode();

          TextEditingController unitPriceNameController = TextEditingController();
          FocusNode unitPriceNameFocus = FocusNode();

          TextEditingController barcodeNameController = TextEditingController();
          FocusNode barcodeNameFocus = FocusNode();

          CustomDialog.showResponsiveDialog(
            context,
            title: 'Create Item',
            StatefulBuilder(builder: (context, s) {
              return Form(
                key: formKey,
                child: Wrap(
                  spacing: 20,
                  runSpacing: 16,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 71,
                          height: 71,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: logoFilePath != null ? Image.file(File(logoFilePath!), fit: BoxFit.cover) : Icon(Icons.image_outlined, size: 60, color: Colors.grey.shade500),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile == null) return;
                            s(() {
                              logoFilePath = pickedFile.path;
                              productModel.image = pickedFile.path;
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(AppColors.primaryColor),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
                          ),
                          child: const Text('Choose Image'),
                        ),
                      ],
                    ),
                    AutoCompleteTextField<String>(
                      items: ['Salable', 'Raw Material'],
                      displayStringFunction: (v) => v,
                      controller: itemTypeController,
                      focusNode: itemTypeFocus,
                      selectedItems: [itemTypeController.text],
                      onSelected: (v) {
                        s(() {
                          productModel.itemType = v;
                        });
                      },
                      defaultText: "Select item type",
                      labelText: 'Select item type',
                    ),
                    AutoCompleteTextField<CategoryModel>(
                      items: categories,
                      displayStringFunction: (v) => v.categoryNameEng ?? "",
                      controller: categoryController,
                      focusNode: categoryFocus,
                      selectedItems: [categoryController.text],
                      onSelected: (v) {
                        productModel.categoryId = v.id;
                        productModel.categoryNameEng = v.categoryNameEng;
                        productModel.categoryNameArabic = v.categoryNameArabic;
                      },
                      defaultText: "Select category",
                      labelText: 'Select category',
                      isLoading: isLoading,
                    ),
                    AutoCompleteTextField<String>(
                      items: units,
                      displayStringFunction: (v) => v,
                      controller: unitController,
                      focusNode: unitFocus,
                      selectedItems: [unitController.text],
                      onSelected: (v) {
                        productModel.unitType = v;
                        s(() {});
                      },
                      defaultText: "Select unit",
                      labelText: 'Select unit',
                      isLoading: isLoading,
                    ),
                    CustomTextField(
                      labelText: 'Minimum Stock Quantity',
                      controller: minimumStockQuantityController,
                      focusNode: minimumStockQuantityFocus,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyBoardType: TextInputType.number,
                      onChanged: (value) {
                        productModel.minStockQty = int.parse(value);
                      },
                      validator: (v) {
                        if (v.isNullOrEmpty()) return 'Enter a valid quantity';
                        return null;
                      },
                    ),
                    CustomTextField(
                      labelText: 'Item Name',
                      controller: itemNameController,
                      focusNode: itemNameFocus,
                      onChanged: (value) {
                        productModel.name = value;
                      },
                      validator: (v) {
                        if (v.isNullOrEmpty()) return 'Item name required';
                        return null;
                      },
                    ),
                    CustomTextField(
                      labelText: 'Item Other Name',
                      controller: itemOtherNameController,
                      focusNode: itemOtherNameFocus,
                      onChanged: (value) {
                        productModel.itemOtherName = value;
                      },
                      validator: (v) {
                        if (v.isNullOrEmpty()) return 'Item other name required';
                        return null;
                      },
                    ),
                    if (itemTypeController.text == "Salable") ...[
                      CustomTextField(
                        labelText: 'Unit Price',
                        controller: unitPriceNameController,
                        focusNode: unitPriceNameFocus,
                        keyBoardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        onChanged: (value) {
                          productModel.unitPrice = double.parse(value);
                        },
                        validator: (v) {
                          if (v.isNullOrEmpty()) return 'Enter unit price';
                          return null;
                        },
                      ),
                      CustomTextField(
                        labelText: 'Barcode',
                        controller: barcodeNameController,
                        focusNode: barcodeNameFocus,
                        keyBoardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          productModel.barcode = int.parse(value);
                        },
                        validator: (v) {
                          if (v.isNullOrEmpty()) return 'Enter barcode';
                          return null;
                        },
                      ),
                    ],
                    CheckboxListTile(
                      value: productModel.addIngredient == 1,
                      onChanged: (val) {
                        if (val ?? false) {
                          productModel.addIngredient = 1;
                          productModel.stockApplicable = 1;
                        } else {
                          productModel.addIngredient = 0;
                        }
                        s(() {});
                      },
                      title: const Text('Add Ingredient'),
                    ),
                    CheckboxListTile(
                      value: productModel.stockApplicable == 1,
                      onChanged: (val) {
                        if (val ?? false) {
                          productModel.stockApplicable = 1;
                        } else {
                          productModel.stockApplicable = 0;
                        }
                        s(() {});
                      },
                      title: const Text('Stock Applicable'),
                    ),
                    CheckboxListTile(
                      value: productModel.hiddenInPos == 1,
                      onChanged: (val) {
                        if (val ?? false) {
                          productModel.hiddenInPos = 1;
                        } else {
                          productModel.hiddenInPos = 0;
                        }
                        s(() {});
                      },
                      title: const Text('Hide in POS'),
                    ),
                    CustomResponsiveButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          // Proceed with save
                          try {
                            CustomDialog.showLoading(context, loadingText: "Creating Item");
                            productModel.unitPrice = double.parse(unitPriceNameController.text);
                            var response = await uploadItemWithImage(productModel, logoFilePath);
                            print(response);
                            if (response.isSuccess) {
                              context.pop();
                            }
                          } catch (e) {
                            print(e);
                          } finally {
                            CustomDialog.hideLoading(context);
                            // context.pop();
                            getAllItems();
                          }
                        }
                      },
                      text: 'Save Item',
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        label: Text(
          'Create Item',
          style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}

Future<ResponseModel> uploadItemWithImage(ProductModel productModel, String? imagePath) async {
  try {
    final Dio _dio = Client().init();
    print(productModel.toJson());
    FormData formData = FormData.fromMap({
      "product_id": 0,
      "product_name": productModel.name,
      "product_image": await MultipartFile.fromFile(imagePath ?? "", filename: imagePath?.split('/').last),
      "product_category_name_eng": productModel.categoryNameEng,
      "product_category_name_arabic": productModel.categoryNameArabic,
      "product_category_id": productModel.categoryId,
      "unit_price": productModel.unitPrice,
      "unit_type": productModel.unitType,
      "item_other_name": productModel.itemOtherName,
      "min_stock_qty": productModel.minStockQty,
      "barcode": productModel.barcode,
      "add_ingredient": productModel.addIngredient,
      "stock_applicable": productModel.stockApplicable,
      "hidden_in_pos": productModel.hiddenInPos,
      "item_type": productModel.itemType
    });
    print(formData.fields);
    print(formData.files);
    final response = await _dio.post(
      Urls.saveProduct,
      data: formData,
      options: Options(headers: {
        ...Urls.getHeaders(),
        'Content-Type': 'multipart/form-data',
      }),
    );
    print('**********************');
    print(response);
    print('**********************');

    final jsonObject = response.data as Map<String, dynamic>;
    return ResponseModel(
      statusCode: response.statusCode!,
      body: json.encode(response.data),
      response: response,
      responseObject: jsonObject,
      errorMessage: jsonObject['message'],
      isSuccess: jsonObject['status'],
    );
  } catch (e) {
    print(e);
    return ResponseModel(
      statusCode: 0,
      body: e.toString(),
      response: null,
      errorMessage: e.toString(),
      isSuccess: false,
      responseObject: {},
    );
  }
}
