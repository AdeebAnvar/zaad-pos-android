import 'package:flutter/material.dart';

class MultipleExpansionCard extends StatefulWidget {
  const MultipleExpansionCard({super.key, required this.titles, required this.childrens, this.initialExpanded = const {0: false}});
  final List<Widget> titles;
  final List<Widget> childrens;
  final Map<int, bool> initialExpanded;
  @override
  State<MultipleExpansionCard> createState() => _MultipleExpansionCardState();
}

class _MultipleExpansionCardState extends State<MultipleExpansionCard> {
  int? expandedIndex;
  List<ExpansionTileController> controllers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllers = List.generate(widget.childrens.length, (index) => ExpansionTileController());
    for (int index in widget.initialExpanded.keys) {
      if (widget.initialExpanded[index] == true) {
        expandedIndex = index;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.titles.length != widget.childrens.length) {
      throw Exception(['titles length and childrens length must be equal condition is not true']);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.childrens.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ExpansionTile(
              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              childrenPadding: EdgeInsets.all(6),
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              tilePadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              key: Key(index.toString()),
              controller: controllers[index],
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: widget.titles[index],
              ),
              initiallyExpanded: expandedIndex == index,
              onExpansionChanged: (isExpanded) {
                if (isExpanded) {
                  for (int i = 0; i < controllers.length; i++) {
                    if (i != index) {
                      controllers[i].collapse();
                    }
                  }
                  setState(() {
                    expandedIndex = index;
                  });
                } else {
                  setState(() {
                    expandedIndex = null;
                  });
                }
              },
              children: [widget.childrens[index]]),
        );
      },
    );
  }
}
