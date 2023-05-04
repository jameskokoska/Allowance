import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';

class DropdownSelect extends StatefulWidget {
  final String initial;
  final List<String> items;
  final Function(String) onChanged;
  final Color? backgroundColor;
  final bool compact;
  final bool
      checkInitialValue; //Check if the initial value not in list, default to using the first index
  final String Function(dynamic) getLabel;
  final bool translate;

  const DropdownSelect({
    Key? key,
    required this.initial,
    required this.items,
    required this.onChanged,
    this.backgroundColor,
    this.compact = false,
    this.checkInitialValue = false,
    required this.getLabel,
    this.translate = true,
  }) : super(key: key);

  @override
  State<DropdownSelect> createState() => _DropdownSelectState();
}

class _DropdownSelectState extends State<DropdownSelect> {
  String? currentValue;

  @override
  void initState() {
    super.initState();
    if (widget.checkInitialValue == true &&
        !widget.items.contains(widget.initial)) {
      currentValue = widget.items[0];
    } else {
      currentValue = widget.initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.compact ? 13 : 15,
          right: widget.compact ? 1 : 6,
          top: widget.compact ? 2 : 10,
          bottom: widget.compact ? 2 : 10),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        underline: Container(),
        style: const TextStyle(fontSize: 15),
        dropdownColor: widget.backgroundColor,
        isDense: true,
        value: currentValue ?? widget.initial,
        elevation: 15,
        iconSize: 32,
        borderRadius: BorderRadius.circular(10),
        icon: const Icon(Icons.arrow_drop_down_rounded),
        onChanged: (String? value) {
          widget.onChanged(value ?? widget.items[0]);
          setState(() {
            currentValue = value;
          });
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            alignment: Alignment.centerLeft,
            value: value,
            child: TextFont(
              text: widget.getLabel(value),
              fontSize: widget.compact ? 14 : 18,
              translate: widget.translate,
            ),
          );
        }).toList(),
      ),
    );
  }
}
