import 'package:budget_simple/pages/main_page_layout.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';

class SpendingTrajectory extends StatefulWidget {
  const SpendingTrajectory({
    Key? key,
    required this.percent,
    required this.todayPercent,
    required this.height,
  }) : super(key: key);

  final double percent;
  final double todayPercent;
  final double height;

  @override
  State<SpendingTrajectory> createState() => _SpendingTrajectoryState();
}

class _SpendingTrajectoryState extends State<SpendingTrajectory> {
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SizedBox(
            height: widget.height * 0.2,
            child: AnimatedFractionallySizedBox(
              widthFactor: loaded ? widget.percent : 0,
              alignment: Alignment.bottomLeft,
              heightFactor: 1,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeInOutCubicEmphasized,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2500),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                      right: loaded == true && widget.percent >= 1
                          ? const Radius.circular(0)
                          : const Radius.circular(20),
                      left: loaded == true && widget.percent >= 1
                          ? const Radius.circular(0)
                          : getIsFullScreen(context)
                              ? const Radius.circular(20)
                              : const Radius.circular(0)),
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
          ),
          IntrinsicHeight(
            child: Align(
              alignment: FractionalOffset(widget.todayPercent, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 3, right: 5, left: 5, bottom: 3),
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 1.0),
                        child: TextFont(
                          textAlign: TextAlign.center,
                          text: "Today",
                          fontSize: 10,
                          textColor: Theme.of(context).brightness ==
                                  Brightness.light
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 4,
                    height: widget.height * 0.2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
