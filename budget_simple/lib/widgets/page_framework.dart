import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class PageFramework extends StatefulWidget {
  const PageFramework({
    required this.childBuilder,
    Key? key,
  }) : super(key: key);

  final Widget Function(ScrollController scrollController) childBuilder;

  @override
  State<PageFramework> createState() => _PageFrameworkState();
}

class _PageFrameworkState extends State<PageFramework>
    with TickerProviderStateMixin {
  late AnimationController _animationControllerDragY;
  final ScrollController _scrollController = ScrollController();
  double totalDragY = 0;
  double totalDragX = 0;
  bool isBackSideSwiping = false;
  double calculatedYOffsetForX = 0;
  double calculatedYOffsetForY = 0;
  bool swipeDownToDismiss = false;
  final double leftBackSwipeDetectionWidth = 50;

  @override
  void initState() {
    super.initState();
    _animationControllerDragY = AnimationController(vsync: this, value: 0);
    _animationControllerDragY.duration = const Duration(milliseconds: 1000);
  }

  @override
  void dispose() {
    _animationControllerDragY.dispose();
    super.dispose();
  }

  _onPointerMove(PointerMoveEvent ptr) {
    if (Navigator.of(context).canPop()) {
      if (isBackSideSwiping) {
        totalDragX = totalDragX + ptr.delta.dx;
        calculatedYOffsetForX = totalDragX / 500;
      }
      if (swipeDownToDismiss) {
        totalDragY = totalDragY + ptr.delta.dy;
        calculatedYOffsetForY = totalDragY / 500;
      }
      _animationControllerDragY.value =
          max(calculatedYOffsetForX, calculatedYOffsetForY);
    }
  }

  _onPointerUp(PointerUpEvent event) async {
    //How far you need to drag to dismiss
    if ((totalDragX >= 90 || totalDragY >= 125) &&
        !(ModalRoute.of(context)?.isFirst ?? true)) {
      await Navigator.of(context).maybePop();
    }
    // This cannot be in an else statement
    // If a popup comes e.g. discard changes and user hits cancel
    // we need to already have had this reset!
    totalDragX = 0;
    totalDragY = 0;
    calculatedYOffsetForY = 0;
    calculatedYOffsetForX = 0;
    isBackSideSwiping = false;
    _animationControllerDragY.reverse();
  }

  _onPointerDown(PointerDownEvent event) {
    if (event.position.dx < leftBackSwipeDetectionWidth &&
        isBackSideSwiping == false) {
      isBackSideSwiping = true;
    }

    if (_scrollController.offset > 0) {
      swipeDownToDismiss = false;
    } else {
      swipeDownToDismiss = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (ptr) => {_onPointerMove(ptr)},
      onPointerUp: (ptr) => {_onPointerUp(ptr)},
      onPointerDown: (ptr) => {_onPointerDown(ptr)},
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Stack(
            children: [
              AnimatedBuilder(
                animation: _animationControllerDragY,
                builder: (_, child) {
                  return Transform.translate(
                    offset: Offset(
                        0,
                        _animationControllerDragY.value *
                            ((1 + 1 - _animationControllerDragY.value) * 50)),
                    child: widget.childBuilder(_scrollController),
                  );
                },
              ),
              // Catch any horizontal drag starts, we catch these so the use cannot scroll while back swiping
              SizedBox(
                width: leftBackSwipeDetectionWidth,
                child: GestureDetector(
                  onHorizontalDragStart: (details) => {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
