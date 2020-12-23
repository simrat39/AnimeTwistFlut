import 'package:flutter/material.dart';
import 'package:spicy_components/spicy_components.dart';

/// Used with [SpicyBottomBar]
class SpicyMenuSheet extends StatefulWidget {
  const SpicyMenuSheet({
    Key key,
    this.items,
    this.onChange,
    this.activeIndex,
    this.bgColor,
    this.activeColor,
  }) : super(key: key);

  final List<SpicyMenuSheetItem> items;
  final Function(int) onChange;
  final int activeIndex;
  final Color bgColor;
  final Color activeColor;

  @override
  _SpicyMenuSheetState createState() => _SpicyMenuSheetState();
}

class _SpicyMenuSheetState extends State<SpicyMenuSheet> {
  @override
  void didUpdateWidget(covariant SpicyMenuSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map(
        (e) {
          int index = widget.items.indexOf(e);
          return ListTile(
            title: Text(
              e.text,
              style: index == widget.activeIndex
                  ? TextStyle(color: widget.activeColor)
                  : TextStyle(),
            ),
            leading: Icon(
              e.icon,
              color: index == widget.activeIndex ? widget.activeColor : null,
            ),
            onTap: () => widget.onChange(widget.items.indexOf(e)),
          );
        },
      ).toList(),
      mainAxisSize: MainAxisSize.min,
    );
  }
}

class SpicyMenuSheetItem {
  const SpicyMenuSheetItem({
    @required this.text,
    @required this.icon,
  });

  final String text;
  final IconData icon;
}
