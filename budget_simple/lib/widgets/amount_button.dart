import 'package:budget_simple/widgets/animated_scale_bounce.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';

class AmountButton extends StatelessWidget {
  const AmountButton({
    super.key,
    required this.constraints,
    required this.text,
    required this.addToAmount,
    this.animationScale,
    this.onLongPress,
    this.heightRatio = 0.25,
    this.widthRatio = 0.25,
    this.color,
    this.child,
  });
  final BoxConstraints constraints;
  final String text;
  final Function(String) addToAmount;
  final double heightRatio;
  final double widthRatio;
  final Color? color;
  final Widget? child;
  final Function? onLongPress;
  final double? animationScale;

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleBounce(
      animationScale: animationScale,
      child: SizedBox(
        width: constraints.maxWidth * widthRatio,
        height: constraints.maxWidth * heightRatio,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Tappable(
            onTap: () {
              addToAmount(text);
            },
            onLongPress: () {
              onLongPress != null ? onLongPress!() : "";
            },
            borderRadius: 1000,
            color: color ?? Theme.of(context).colorScheme.secondaryContainer,
            child: child ??
                Center(
                  child: TextFont(
                    autoSizeText: true,
                    minFontSize: 15,
                    maxFontSize: 28,
                    maxLines: 2,
                    fontSize: 28,
                    text: text,
                    textColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    translate: false,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
