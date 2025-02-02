import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';

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
  });

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

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller ?? _controller,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus ? AppColors.primaryColor : Colors.white,
              width: 1.5,
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
                      if ((widget.showAsUpperLabel ?? true) && widget.labelText != null && widget.labelText!.isNotEmpty && value.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5),
                          child: Text(
                            textAlign: TextAlign.start,
                            widget.labelText!,
                            style: AppStyles.getRegularTextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      TextFormField(
                        onTapOutside: (event) => hideKeyboard(),
                        autofillHints: widget.autofillHints,
                        enabled: widget.enabled,
                        readOnly: widget.readOnly ?? false,
                        controller: _controller,
                        focusNode: _focusNode,
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
                        cursorColor: Colors.black,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.textColor ?? AppColors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: widget.textAlign ?? TextAlign.start,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontSize: widget.hintFontSize ?? 14,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: false,
                          hintText: widget.labelText,
                          counterText: widget.counterText,
                          fillColor: widget.fillColor ?? Colors.white,
                          hintStyle: TextStyle(
                            fontSize: widget.hintFontSize ?? 14,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                          isCollapsed: true,
                          contentPadding: widget.contentPadding ??
                              EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: (value.text.isEmpty)
                                    ? 15
                                    : (widget.showAsUpperLabel ?? true)
                                        ? 4
                                        : 15,
                              ),
                          suffix: widget.suffix,
                          prefix: widget.prefix,
                          errorText: widget.errorText,
                          errorStyle: const TextStyle(
                            fontSize: 10,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 5),
                    child: Center(child: widget.suffixIcon!),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

hideKeyboard() async {
  FocusManager.instance.primaryFocus?.unfocus();
}
