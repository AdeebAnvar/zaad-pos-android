import 'package:flutter/material.dart';

import '../constatnts/colors.dart';
import '../constatnts/styles.dart';
import '../data/models/category_model.dart';

class CategoryButton extends StatefulWidget {
  const CategoryButton({super.key, this.isSelected = false, required this.category, required this.onPressed});
  final bool isSelected;
  final CategoryModel category;
  final void Function() onPressed;

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        child: ActionChip(
          shadowColor: Colors.black26,
          elevation: widget.isSelected ? 8 : 0,
          surfaceTintColor: WidgetStateColor.transparent,
          color: WidgetStateProperty.all(widget.isSelected ? AppColors.primaryColor : Colors.white),
          onPressed: widget.onPressed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          label: Text(
            widget.category.name,
            style: AppStyles.getMediumTextStyle(fontSize: 12, color: widget.isSelected ? Colors.white : null),
          ),
        ),
      ),
    );
  }
}
