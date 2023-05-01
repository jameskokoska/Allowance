import 'package:budget_simple/struct/colors.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';

class SelectColor extends StatefulWidget {
  const SelectColor({
    Key? key,
    this.setSelectedColor,
    this.selectedColor,
    this.includeThemeColor = true, // Will return null if theme color is chosen
  }) : super(key: key);
  final Function(Color?)? setSelectedColor;
  final Color? selectedColor;
  final bool includeThemeColor;

  @override
  _SelectColorState createState() => _SelectColorState();
}

class _SelectColorState extends State<SelectColor> {
  Color? selectedColor;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.selectedColor != null) {
      int index = 0;
      Future.delayed(Duration.zero, () {
        for (Color color in selectableColors(context)) {
          if (color.toString() == widget.selectedColor.toString()) {
            setState(() {
              selectedIndex = index;
              selectedColor = widget.selectedColor;
            });
            return;
          }
          index++;
        }
      });
    } else {
      setState(() {
        selectedIndex = 0;
        selectedColor = null;
      });
    }
  }

  //find the selected category using selectedCategory
  @override
  Widget build(BuildContext context) {
    List<Color> selectableColorsList = selectableColors(context);
    if (widget.includeThemeColor) {
      selectableColorsList.insert(0, Colors.transparent);
    }

    return ListView.builder(
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      itemCount: selectableColorsList.length,
      itemBuilder: (context, index) {
        Color color;
        color = selectableColorsList[index];
        return Padding(
          padding: EdgeInsets.only(
              left: index == 0 ? 12 : 0,
              right: index + 1 == selectableColorsList.length ? 12 : 0),
          child: widget.includeThemeColor && index == 0
              ? ThemeColorIcon(
                  outline: selectedIndex == 0 && selectedColor == null,
                  margin: const EdgeInsets.all(5),
                  size: 55,
                  onTap: () {
                    widget.setSelectedColor!(null);
                    setState(() {
                      selectedColor = null;
                      selectedIndex = index;
                    });
                  },
                )
              : ColorIcon(
                  margin: const EdgeInsets.all(5),
                  color: color,
                  size: 55,
                  onTap: () {
                    if (widget.setSelectedColor != null) {
                      widget.setSelectedColor!(color);
                      setState(() {
                        selectedColor = color;
                        selectedIndex = index;
                      });
                    }
                  },
                  outline: (selectedIndex != null &&
                          selectedIndex == selectableColorsList.length - 1 &&
                          index == selectedIndex) ||
                      selectedColor.toString() == color.toString(),
                ),
        );
      },
    );
  }
}

class ColorIcon extends StatelessWidget {
  const ColorIcon({
    Key? key,
    required this.color,
    required this.size,
    this.onTap,
    this.margin,
    this.outline = false,
  }) : super(key: key);

  final Color color;
  final double size;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin:
          margin ?? const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      height: size,
      width: size,
      decoration: outline
          ? BoxDecoration(
              border: Border.all(
                color: dynamicPastel(context, color,
                    amountLight: 0.5, amountDark: 0.4, inverse: true),
                width: 3,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(500)),
            )
          : BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
                width: 0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(500)),
            ),
      child: Tappable(
        color: color,
        onTap: onTap,
        borderRadius: 500,
        child: Container(),
      ),
    );
  }
}

class ThemeColorIcon extends StatelessWidget {
  const ThemeColorIcon({
    Key? key,
    required this.size,
    required this.onTap,
    this.margin,
    required this.outline,
  }) : super(key: key);

  final double size;
  final Function()? onTap;
  final EdgeInsets? margin;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin:
          margin ?? const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      height: size,
      width: size,
      decoration: outline
          ? BoxDecoration(
              border: Border.all(
                color: dynamicPastel(
                    context, Theme.of(context).colorScheme.primary,
                    amountLight: 0.5, amountDark: 0.4, inverse: true),
                width: 3,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(500)),
            )
          : BoxDecoration(
              border: Border.all(
                color: Colors.transparent,
                width: 0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(500)),
            ),
      child: Tappable(
        color: SystemTheme.accentColor.accent.withOpacity(0.4),
        onTap: onTap,
        borderRadius: 500,
        child: Icon(
          Icons.color_lens_rounded,
          color: SystemTheme.accentColor.accent.withOpacity(0.9),
        ),
      ),
    );
  }
}
