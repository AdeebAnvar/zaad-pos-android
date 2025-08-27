import 'package:flutter/material.dart';

class SaleControllers {
  static initialize() {
    searchController = TextEditingController();
    barcodeController = TextEditingController();
    searchFocusNode = FocusNode();
    barcodeFocusNode = FocusNode();
  }

  static TextEditingController searchController = TextEditingController();
  static TextEditingController barcodeController = TextEditingController();
  static FocusNode searchFocusNode = FocusNode();
  static FocusNode barcodeFocusNode = FocusNode();
}
