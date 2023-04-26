import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedScaleBounce extends StatefulWidget {
  const AnimatedScaleBounce(
      {Key? key, required this.child, this.animationScale})
      : super(key: key);
  final Widget child;
  final double? animationScale;
  @override
  _AnimatedScaleBounceState createState() => _AnimatedScaleBounceState();
}

class _AnimatedScaleBounceState extends State<AnimatedScaleBounce>
    with TickerProviderStateMixin {
  double squareScaleA = 1;
  late AnimationController _controllerA;
  late Animation<double> _animationA;
  @override
  void initState() {
    _controllerA = AnimationController(
      vsync: this,
      lowerBound: widget.animationScale ?? 0.8,
      upperBound: 1.0,
      value: 1,
      duration: const Duration(milliseconds: 80),
    );
    _animationA = CurvedAnimation(
      parent: _controllerA,
      curve: Curves.easeInOutBack,
    );
    _animationA.addListener(() {
      setState(() {
        squareScaleA = _animationA.value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _controllerA.reverse();
      },
      onExit: (_) {
        Timer(const Duration(milliseconds: 50), () {
          _controllerA.fling();
        });
      },
      child: Listener(
        onPointerDown: (_) {
          _controllerA.reverse();
        },
        onPointerUp: (dp) {
          Timer(const Duration(milliseconds: 50), () {
            _controllerA.fling();
          });
        },
        onPointerCancel: (_) {
          _controllerA.fling();
        },
        child: Transform.scale(
          scale: squareScaleA,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerA.dispose();
    super.dispose();
  }
}
