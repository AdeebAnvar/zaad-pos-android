import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/custom_textfield.dart';
import 'package:pos_app/data/utils/extensions.dart';

class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key, this.productModel});
  static String route = '/create_item';
  final ProductModel? productModel;
  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
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

  List<CategoryModel> categories = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  void dispose() {
    itemTypeController.dispose();
    itemTypeFocus.dispose();

    categoryController.dispose();
    categoryFocus.dispose();

    unitController.dispose();
    unitFocus.dispose();

    minimumStockQuantityController.dispose();
    minimumStockQuantityFocus.dispose();

    itemNameController.dispose();
    itemNameFocus.dispose();

    itemOtherNameController.dispose();
    itemOtherNameFocus.dispose();

    unitPriceNameController.dispose();
    unitPriceNameFocus.dispose();

    barcodeNameController.dispose();
    barcodeNameFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool addIngredient = false;
    bool stockApplicable = false;
    bool hideInPOS = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create item',
          style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
      body: Form(
        key: formKey,
        child: LayoutBuilder(builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 900;
          final double fieldWidth = isWide ? (constraints.maxWidth / 2) - 60 : constraints.maxWidth;
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: Row(
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
                            setState(() {
                              logoFilePath = pickedFile.path;
                              widget.productModel?.image = pickedFile.path;
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
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: AutoCompleteTextField<String>(
                      items: ['Salable', 'Raw Material'],
                      displayStringFunction: (v) => v,
                      controller: itemTypeController,
                      focusNode: itemTypeFocus,
                      selectedItems: [itemTypeController.text],
                      onSelected: (v) {
                        setState(() {});
                      },
                      defaultText: "Select item type",
                      labelText: 'Select item type',
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: AutoCompleteTextField<CategoryModel>(
                      items: categories,
                      displayStringFunction: (v) => v.categoryNameEng ?? "",
                      controller: categoryController,
                      focusNode: categoryFocus,
                      selectedItems: [categoryController.text],
                      onSelected: (v) {},
                      defaultText: "Select category",
                      labelText: 'Select category',
                      isLoading: isLoading,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: AutoCompleteTextField<String>(
                      items: units,
                      displayStringFunction: (v) => v,
                      controller: unitController,
                      focusNode: unitFocus,
                      selectedItems: [unitController.text],
                      onSelected: (v) {},
                      defaultText: "Select unit",
                      labelText: 'Select unit',
                      isLoading: isLoading,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CustomTextField(
                      labelText: 'Minimum Stock Quantity',
                      controller: minimumStockQuantityController,
                      focusNode: minimumStockQuantityFocus,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyBoardType: TextInputType.number,
                      onChanged: (value) {
                        widget.productModel?.minStockQty = int.tryParse(value);
                      },
                      validator: (v) {
                        if (v.isNullOrEmpty()) return 'Enter a valid quantity';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CustomTextField(
                      labelText: 'Item Name',
                      controller: itemNameController,
                      focusNode: itemNameFocus,
                      onChanged: (value) {
                        widget.productModel?.name = value;
                      },
                      validator: (v) {
                        if (v.isNullOrEmpty()) return 'Item name required';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CustomTextField(
                      labelText: 'Item Other Name',
                      controller: itemOtherNameController,
                      focusNode: itemOtherNameFocus,
                      onChanged: (value) {
                        widget.productModel?.itemOtherName = value;
                      },
                      validator: (v) {
                        if (v.isNullOrEmpty()) return 'Item other name required';
                        return null;
                      },
                    ),
                  ),
                  if (itemTypeController.text == "Salable") ...[
                    SizedBox(
                      width: fieldWidth,
                      child: CustomTextField(
                        labelText: 'Unit Price',
                        controller: unitPriceNameController,
                        focusNode: unitPriceNameFocus,
                        keyBoardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        onChanged: (value) {
                          widget.productModel?.unitPrice = double.tryParse(value);
                        },
                        validator: (v) {
                          if (v.isNullOrEmpty()) return 'Enter unit price';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: CustomTextField(
                        labelText: 'Barcode',
                        controller: barcodeNameController,
                        focusNode: barcodeNameFocus,
                        keyBoardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          widget.productModel?.barcode = int.parse(value);
                        },
                        validator: (v) {
                          if (v.isNullOrEmpty()) return 'Enter barcode';
                          return null;
                        },
                      ),
                    ),
                  ],
                  SizedBox(
                    width: fieldWidth,
                    child: CheckboxListTile(
                      value: addIngredient,
                      onChanged: (val) {
                        setState(() {
                          addIngredient = val ?? false;
                          if (addIngredient) stockApplicable = true;
                        });
                      },
                      title: const Text('Add Ingredient'),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CheckboxListTile(
                      value: stockApplicable,
                      onChanged: (val) {
                        setState(() {
                          stockApplicable = val ?? false;
                        });
                      },
                      title: const Text('Stock Applicable'),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CheckboxListTile(
                      value: hideInPOS,
                      onChanged: (val) {
                        setState(() {
                          hideInPOS = val ?? false;
                        });
                      },
                      title: const Text('Hide in POS'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          // Proceed with save
                        }
                      },
                      child: const Text('Save Item'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

List<String> units = [
  'mm - millimeter',
  'cm - centimeter',
  'm - meter',
  'km - kilometer',
  'in - inch',
  'ft - foot',
  'yd - yard',
  'mi - mile',
  'mg - milligram',
  'g - gram',
  'kg - kilogram',
  'oz - ounce',
  'lb - pound',
  'ton - ton',
  'ml - milliliter',
  'l - liter',
  'cl - centiliter',
  'cup - cup',
  'pt - pint',
  'qt - quart',
  'gal - gallon',
  'fl oz - fluid ounce',
  'pcs - pieces',
  'dozen - dozen',
  'pack - pack',
  'unit - unit',
  'set - set',
];
