import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/utils/extensions.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      this.controller,
      // this.hintText,
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
      this.contentPadding});
  final TextEditingController? controller;
  final EdgeInsetsGeometry? margin;
  final TextInputAction? textInputAction;
  // final String? hintText;
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
  }

  @override
  void dispose() {
    // Only dispose if we created the focus node
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    // Only dispose if we created the controller
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        // height: 55,//if set fixed height multi line text overflow
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller!,
            builder: (context, value, child) {
              return IntrinsicHeight(
                  // Added to maintain consistent height
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Makes children stretch to match height
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
                          if ((widget.showAsUpperLabel ?? true) && !widget.labelText.isNullOrEmpty() && !value.text.isNullOrEmpty())
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, top: 5),
                              child: Text(
                                widget.labelText ?? "",
                                textAlign: TextAlign.start,
                                style: AppStyles.getMediumTextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          // if(value.text.isNullOrEmpty())
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          TextFormField(
                            autofillHints: widget.autofillHints,
                            enabled: widget.enabled,
                            readOnly: widget.readOnly!,
                            controller: _controller,
                            focusNode: _focusNode,
                            textInputAction: widget.textInputAction,
                            obscureText: widget.obscureText!,
                            inputFormatters: widget.inputFormatters,
                            onChanged: widget.onChanged,
                            onFieldSubmitted: widget.onSubmitted,
                            maxLines: widget.maxLines,
                            minLines: widget.minLines,
                            onTap: widget.onTap,
                            keyboardType: widget.keyBoardType,
                            textCapitalization: widget.textCapitalization,
                            cursorColor: Colors.grey.shade400,
                            style: AppStyles.getMediumTextStyle(fontSize: 14),
                            textAlign: widget.textAlign ?? TextAlign.start,
                            decoration: InputDecoration(
                              labelStyle: AppStyles.getRegularTextStyle(
                                color: Colors.grey.shade600,
                                fontSize: widget.hintFontSize ?? 14,
                              ),
                              // suffixIconConstraints: const BoxConstraints(minWidth: 30),
                              filled: false,
                              hintText: widget.labelText,

                              counterText: widget.counterText,
                              fillColor: widget.fillColor ?? Colors.white,
                              // fillColor: AppColors.white,

                              hintStyle: AppStyles.getRegularTextStyle(
                                color: Colors.grey.shade600,
                                fontSize: widget.hintFontSize ?? 14,
                              ),
                              isDense: true,
                              isCollapsed: true,
                              contentPadding: widget.contentPadding ??
                                  EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: (value.text.isNullOrEmpty())
                                          ? 15
                                          : (widget.showAsUpperLabel ?? true)
                                              ? 4
                                              : 15),
                              // suffixIcon: suffixIcon,
                              suffix: widget.suffix,
                              // prefixIcon: prefixIcon,
                              prefix: widget.prefix,
                              errorText: widget.errorText,
                              errorStyle: const TextStyle(
                                fontSize: 10,
                                fontFamily: "Inter",
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
                  ]));
            }),
      ),
    );
  }
}
