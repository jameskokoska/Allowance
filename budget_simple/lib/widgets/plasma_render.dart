import 'package:flutter/material.dart';
import 'package:sa3_liquid/liquid/plasma/plasma.dart';

class PlasmaRender extends StatelessWidget {
  const PlasmaRender({
    super.key,
    required this.color,
    this.randomOffset = 1,
  });

  final Color color;
  final int randomOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
      ),
      child: PlasmaRenderer(
        key: ValueKey(key),
        type: PlasmaType.infinity,
        particles: 10,
        color: Theme.of(context).brightness == Brightness.light
            ? color.withOpacity(0.45)
            : Color.alphaBlend(
                Colors.white.withOpacity(0.7),
                color,
              ),
        blur: 0.2,
        size: 1.3,
        speed: Theme.of(context).brightness == Brightness.light ? 4.3 : 3,
        offset: 0,
        blendMode: BlendMode.multiply,
        particleType: ParticleType.atlas,
        variation1: 0,
        variation2: 0,
        variation3: 0,
      ),
    );
  }
}
