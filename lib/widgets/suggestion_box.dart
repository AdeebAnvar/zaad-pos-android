import 'package:flutter/material.dart';

class SuggestionBox extends StatefulWidget {
  SuggestionBox({super.key, required this.suggestions, required this.searchQueryController, required this.isOpenedSuggestionBox});
  final List<String> suggestions;
  final TextEditingController searchQueryController;
  bool isOpenedSuggestionBox;
  @override
  State<SuggestionBox> createState() => _SuggestionBoxState();
}

class _SuggestionBoxState extends State<SuggestionBox> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.bounceInOut,
      right: 1,
      left: 1,
      top: MediaQuery.sizeOf(context).height / 6.9,
      child: Container(
        margin: const EdgeInsets.all(10),
        constraints: const BoxConstraints(minHeight: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              blurRadius: 8,
              color: Colors.black26,
              spreadRadius: 0.1,
            ),
          ],
        ),
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: widget.suggestions
              .map((String e) => ListTile(
                    onTap: () {
                      widget.searchQueryController.clear();
                      widget.searchQueryController.text = e;
                      setState(() {
                        if (widget.isOpenedSuggestionBox) {
                          widget.isOpenedSuggestionBox = false;
                        }
                      });
                    },
                    title: Text(e),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
