import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pos_app/constatnts/colors.dart'; // Fixed typo

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hintFontSize,
    this.labelText,
    this.showAsUpperLabel,
    this.margin,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.obscureText = false,
    this.onTap,
    this.onSubmitted,
    this.keyBoardType,
    this.textCapitalization = TextCapitalization.none,
    this.errorText,
    this.changeColor,
    this.fillColor,
    this.readOnly = false,
    this.enabled = true,
    this.autofillHints,
    this.onIconTap,
    this.suffixIcon,
    this.suffix,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.textColor,
    this.maxLines = 1,
    this.minLines = 1,
    this.counterText,
    this.textAlign,
    this.prefixIcon,
    this.prefix,
    this.contentPadding,
  })  : assert(
          maxLines == null || maxLines > 0,
          'maxLines must be greater than 0',
        ),
        assert(
          minLines == null || minLines > 0,
          'minLines must be greater than 0',
        ),
        assert(
          maxLines == null || minLines == null || maxLines >= minLines,
          'maxLines must be greater than or equal to minLines',
        );

  final TextEditingController? controller;
  final EdgeInsetsGeometry? margin;
  final TextInputAction? textInputAction;
  final double? hintFontSize;
  final String? labelText;
  final bool? showAsUpperLabel;
  final String? counterText;
  final Color? fillColor;
  final FocusNode? focusNode;
  final bool? obscureText;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final void Function()? onTap;
  final TextInputType? keyBoardType;
  final TextCapitalization textCapitalization;
  final String? errorText;
  final bool? changeColor;
  final bool? readOnly;
  final bool? enabled;
  final Iterable<String>? autofillHints;
  final void Function()? onIconTap;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? prefix;
  final String? Function(String? value)? validator;
  final int? maxLength;
  final Color? textColor;
  final int? maxLines;
  final int? minLines;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();

    // Only add listener if we need to track focus state
    if (widget.focusNode == null) {
      _focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (_hasFocus != _focusNode.hasFocus) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    try {
      if (widget.focusNode == null) {
        _focusNode.removeListener(_onFocusChange);
        _focusNode.dispose();
      }
      if (widget.controller == null) {
        _controller.dispose();
      }
    } catch (e) {
      if (kDebugMode) {
        print('CustomTextField dispose error: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveController = widget.controller ?? _controller;
    final effectiveFocusNode = widget.focusNode ?? _focusNode;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: effectiveController,
      builder: (context, value, child) {
        return Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            color: widget.fillColor ?? Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1.5,
              color: widget.errorText != null
                  ? Colors.red
                  : _hasFocus
                      ? Theme.of(context).primaryColor
                      : Colors.black26,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.prefixIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Center(child: widget.prefixIcon!),
                  ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showAsUpperLabel == true && widget.labelText != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                          child: Text(
                            widget.labelText!,
                            style: TextStyle(
                              fontSize: (widget.hintFontSize ?? 14) - 2,
                              color: AppColors.hintFontColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      TextFormField(
                        onTapOutside: (event) => hideKeyboard(),
                        autofillHints: widget.autofillHints,
                        enabled: widget.enabled,
                        readOnly: widget.readOnly ?? false,
                        controller: effectiveController,
                        focusNode: effectiveFocusNode,
                        textInputAction: widget.textInputAction,
                        obscureText: widget.obscureText ?? false,
                        inputFormatters: widget.inputFormatters,
                        onChanged: widget.onChanged,
                        onFieldSubmitted: widget.onSubmitted,
                        maxLines: widget.maxLines,
                        minLines: widget.minLines,
                        onTap: widget.onTap,
                        keyboardType: widget.keyBoardType,
                        textCapitalization: widget.textCapitalization,
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.textColor ?? AppColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: widget.textAlign ?? TextAlign.start,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: AppColors.hintFontColor,
                            fontSize: widget.hintFontSize ?? 14,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: false,
                          hintText: widget.showAsUpperLabel == true ? null : widget.labelText,
                          counterText: widget.counterText,
                          fillColor: widget.fillColor ?? Colors.white,
                          hintStyle: TextStyle(
                            color: AppColors.hintFontColor,
                            fontSize: widget.hintFontSize ?? 14,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                          isCollapsed: true,
                          contentPadding: widget.contentPadding ??
                              EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: widget.showAsUpperLabel == true ? 8 : 13,
                              ),
                          suffix: widget.suffix,
                          prefix: widget.prefix,
                          errorText: widget.errorText,
                          errorStyle: const TextStyle(
                            fontSize: 10,
                            height: 1,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        validator: widget.validator,
                        maxLength: widget.maxLength,
                      ),
                    ],
                  ),
                ),
                if (widget.suffixIcon != null)
                  GestureDetector(
                    onTap: widget.onIconTap,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Center(child: widget.suffixIcon!),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}
