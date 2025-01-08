import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pos_app/widgets/custom_textfield.dart';

enum FilterType { startWith, endWith, contains }

typedef AutocompleteListWidget<T extends Object> = Widget Function(T options);

class AutoCompleteTextField<T extends Object> extends StatelessWidget {
  final List<T> items;
  final String Function(T model) displayStringFunction;
  final List<String> Function(T model)? searchFunction;
  final String defaultText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? showAsUpperLabel;
  final void Function(T model) onSelected;
  final void Function(String value)? onChanged;
  final FocusNode? focusNode;
  final OptionsViewOpenDirection optionsViewOpenDirection;
  final bool enabled;
  final bool disableSearch;
  final FilterType filterType;
  final TextEditingController? controller;
  final bool isLoading;
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;
  final AutocompleteListWidget<T>? viewWidget;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? selectedItems;
  final String? Function(String? value)? validator;
  final void Function(String)? onSubmitted;

  const AutoCompleteTextField({
    super.key,
    required this.items,
    required this.displayStringFunction,
    required this.onSelected,
    required this.defaultText,
    this.isLoading = false,
    this.onChanged,
    this.optionsViewBuilder,
    this.searchFunction,
    this.selectedItems,
    this.viewWidget,
    this.disableSearch = false,
    this.labelText,
    this.showAsUpperLabel,
    this.focusNode,
    this.inputFormatters,
    this.enabled = true,
    this.filterType = FilterType.contains,
    this.controller,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
  });

  List<T> _filterItems(String searchText) {
    if (searchText.isEmpty) return items;

    return items.where((option) {
      final searchStrings = searchFunction?.call(option) ?? [displayStringFunction(option)];
      return searchStrings.any((element) {
        final lowercaseElement = element.toLowerCase();
        final lowercaseSearch = searchText.toLowerCase();

        switch (filterType) {
          case FilterType.startWith:
            return lowercaseElement.startsWith(lowercaseSearch);
          case FilterType.endWith:
            return lowercaseElement.endsWith(lowercaseSearch);
          case FilterType.contains:
            return lowercaseElement.contains(lowercaseSearch);
        }
      });
    }).toList();
  }

  Widget _buildOptionsView(BuildContext context, void Function(T) onSelected, Iterable<T> options, BoxConstraints constraints) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => FocusScope.of(context).unfocus(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Align(
          alignment: optionsViewOpenDirection == OptionsViewOpenDirection.up ? Alignment.bottomLeft : Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Material(
              shadowColor: const Color(0xffb8b8b826),
              borderRadius: BorderRadius.circular(14),
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 400,
                    maxWidth: constraints.biggest.width,
                  ),
                  child: _buildOptionsList(options, onSelected),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsList(Iterable<T> options, void Function(T) onSelected) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (context, index) => _buildOptionItem(
        context,
        options.elementAt(index),
        onSelected,
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, T option, void Function(T) onSelected) {
    final isSelected = selectedItems?.map((item) => item.toLowerCase()).contains(displayStringFunction(option).toLowerCase());

    return InkWell(
      onTap: () => onSelected(option),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
        child: Builder(
          builder: (context) {
            if (isSelected == true) {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) => Scrollable.ensureVisible(context, alignment: 0.5),
              );
            }

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected == true ? Theme.of(context).focusColor : null,
              ),
              child: viewWidget?.call(option) ??
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      displayStringFunction(option),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<T>(
        optionsViewOpenDirection: optionsViewOpenDirection,
        focusNode: focusNode ?? FocusNode(),
        textEditingController: controller ?? TextEditingController(),
        optionsBuilder: (textEditingValue) => _filterItems(textEditingValue.text),
        onSelected: (T value) {
          focusNode?.unfocus();
          onSelected(value);
        },
        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
          return SizedBox(
            width: constraints.biggest.width,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: textEditingController,
              builder: (context, value, _) => CustomTextField(
                labelText: labelText,
                controller: controller ?? textEditingController,
                enabled: enabled,
                readOnly: disableSearch,
                onChanged: disableSearch ? (_) => textEditingController.clear() : onChanged,
                inputFormatters: inputFormatters,
                validator: validator,
                suffixIcon: _buildSuffixIcon(textEditingController, focusNode),
                prefixIcon: prefixIcon,
                showAsUpperLabel: showAsUpperLabel,
                onTap: () => _handleTextFieldTap(textEditingController, focusNode),
                focusNode: focusNode,
                onSubmitted: (value) {
                  onFieldSubmitted();
                  onSubmitted?.call(value);
                },
              ),
            ),
          );
        },
        displayStringForOption: displayStringFunction,
        optionsViewBuilder: optionsViewBuilder ??
            (context, onSelected, options) => _buildOptionsView(
                  context,
                  onSelected,
                  options,
                  constraints,
                ),
      ),
    );
  }

  Widget _buildSuffixIcon(TextEditingController controller, FocusNode focusNode) {
    return InkWell(
      onTap: () {
        focusNode.requestFocus();
        controller.clear();
        onChanged?.call("");
      },
      child: suffixIcon ??
          Icon(
            controller.text.isEmpty ? Icons.keyboard_arrow_down_outlined : Icons.clear_outlined,
            color: Colors.grey.shade600,
            size: 16,
          ),
    );
  }

  void _handleTextFieldTap(TextEditingController controller, FocusNode focusNode) {
    if (!focusNode.hasFocus) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    }

    if (disableSearch) {
      focusNode.requestFocus();
      controller.clear();
      onChanged?.call("");
    }
  }
}
