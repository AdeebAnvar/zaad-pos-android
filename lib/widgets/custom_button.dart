import 'package:flutter/material.dart';
import 'package:pos_app/constatnts/colors.dart';

class CustomResponsiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isFullWidth;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color textColor;
  final double fontSize;
  final double elevation;
  const CustomResponsiveButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isFullWidth = true,
    this.width,
    this.height = 46,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.elevation = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = width ?? (isFullWidth ? screenWidth : screenWidth * 0.6);

    if (screenWidth > 1000 && isFullWidth) {
      buttonWidth = 600;
    }

    return SizedBox(
      width: buttonWidth,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: elevation,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
