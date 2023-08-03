import 'package:budget_simple/widgets/dropdown_select.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({
    Key? key,
    required this.title,
    this.description,
    this.icon,
    this.afterWidget,
    this.onTap,
    this.verticalPadding,
    this.iconSize,
  }) : super(key: key);

  final String title;
  final String? description;
  final IconData? icon;
  final Widget? afterWidget;
  final VoidCallback? onTap;
  final double? verticalPadding;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 450;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Tappable(
        color: Colors.transparent,
        onTap: onTap,
        child: Column(
          children: [
            Container(),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: verticalPadding ?? 11,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            icon == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Icon(
                                      icon,
                                      size: iconSize ?? 30,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                            Expanded(
                              child: description == null
                                  ? TextFont(
                                      fixParagraphMargin: true,
                                      text: title,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      maxLines: 5,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFont(
                                          fixParagraphMargin: true,
                                          text: title,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          maxLines: 5,
                                        ),
                                        Container(height: 3),
                                        TextFont(
                                          text: description!,
                                          fontSize: 14,
                                          maxLines: 5,
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: afterWidget ?? const SizedBox(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsContainerSwitch extends StatefulWidget {
  const SettingsContainerSwitch({
    required this.title,
    this.description,
    this.descriptionWithValue,
    this.initialValue = false,
    this.icon,
    required this.onSwitched,
    this.verticalPadding,
    this.syncWithInitialValue = true,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? description;
  final String Function(bool)? descriptionWithValue;
  final bool initialValue;
  final IconData? icon;
  final Function(bool) onSwitched;
  final double? verticalPadding;
  final bool syncWithInitialValue;

  @override
  State<SettingsContainerSwitch> createState() =>
      _SettingsContainerSwitchState();
}

class _SettingsContainerSwitchState extends State<SettingsContainerSwitch> {
  bool value = true;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    if (widget.initialValue != value && widget.syncWithInitialValue) {
      setState(() {
        value = widget.initialValue;
      });
    }
  }

  void toggleSwitch() async {
    setState(() {
      waiting = true;
    });
    if (await widget.onSwitched(!value) != false) {
      setState(() {
        value = !value;
        waiting = false;
      });
    } else {
      setState(() {
        waiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? description = widget.description;
    if (widget.descriptionWithValue != null) {
      description = widget.descriptionWithValue!(value);
    }
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: waiting ? 0.5 : 1,
      child: SettingsContainer(
        onTap: () => {toggleSwitch()},
        title: widget.title,
        description: description,
        afterWidget: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Switch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: value,
            onChanged: (_) {
              toggleSwitch();
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        icon: widget.icon,
        verticalPadding: widget.verticalPadding,
      ),
    );
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 63.0,
        top: 15,
        bottom: 7,
      ),
      child: TextFont(
        text: title,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class SettingsContainerDropdown extends StatefulWidget {
  const SettingsContainerDropdown({
    Key? key,
    required this.title,
    this.description,
    this.icon,
    required this.initial,
    required this.items,
    required this.onChanged,
    this.verticalPadding,
    required this.getLabel,
    this.translate = true,
  }) : super(key: key);

  final String title;
  final String? description;
  final IconData? icon;
  final String initial;
  final List<String> items;
  final Function(String) onChanged;
  final double? verticalPadding;
  final String Function(dynamic) getLabel;
  final bool translate;

  @override
  State<SettingsContainerDropdown> createState() =>
      _SettingsContainerDropdownState();
}

class _SettingsContainerDropdownState extends State<SettingsContainerDropdown> {
  late final GlobalKey<DropdownSelectState>? _dropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SettingsContainer(
      verticalPadding: widget.verticalPadding,
      title: widget.title,
      description: widget.description,
      icon: widget.icon,
      onTap: () {
        _dropdownKey!.currentState!.openDropdown();
      },
      afterWidget: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: DropdownSelect(
          key: _dropdownKey,
          compact: true,
          initial: widget.items.contains(widget.initial) == false
              ? widget.items[0]
              : widget.initial,
          items: widget.items,
          onChanged: widget.onChanged,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          getLabel: widget.getLabel,
          translate: widget.translate,
        ),
      ),
    );
  }
}
