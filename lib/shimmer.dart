///
/// A package provides an easy way to add shimmer effect to Flutter application
///

library shimmer;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
/// An enum defines all supported directions of shimmer effect
///
/// * [ShimmerDirection.ltr] left to right direction
/// * [ShimmerDirection.rtl] right to left direction
/// * [ShimmerDirection.ttb] top to bottom direction
/// * [ShimmerDirection.btt] bottom to top direction
/// * [ShimmerDirection.slanted] slanted 30 degrees in clockwise direction
///

///
/// A widget renders shimmer effect over [child] widget tree.
///
/// [child] defines an area that shimmer effect blends on. You can build [child]
/// from whatever [Widget] you like but there're some notices in order to get
/// exact expected effect and get better rendering performance:
///
/// * Use static [Widget] (which is an instance of [StatelessWidget]).
/// * [Widget] should be a solid color element. Every colors you set on these
/// [Widget]s will be overridden by colors of [gradient].
/// * Shimmer effect only affects to opaque areas of [child], transparent areas
/// still stays transparent.
///
/// [period] controls the speed of shimmer effect. The default value is 1500
/// milliseconds.
///
/// [direction] controls the direction of shimmer effect. The default value
/// is [ShimmerDirection.ltr].
///
/// [gradient] controls colors of shimmer effect.
///
/// [loop] the number of animation loop, set value of `0` to make animation run
/// forever.
///
/// [enabled] controls if shimmer effect is active. When set to false the animation
/// is paused
///
///
/// ## Pro tips:
///
/// * [child] should be made of basic and simple [Widget]s, such as [Container],
/// [Row] and [Column], to avoid side effect.
///
/// * use one [Shimmer] to wrap list of [Widget]s instead of a list of many [Shimmer]s
///

enum ShimmerDirection {
  ltr(0),
  ttb(90),
  rtl(180),
  btt(270),
  slanted(30);

  final double val;
  const ShimmerDirection(this.val);
}

@immutable
class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;
  final bool reversed;
  final Duration delay;

  const Shimmer({
    super.key,
    required this.child,
    required this.gradient,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.delay = Duration.zero,
    this.reversed = false,
    this.enabled = true,
  });

  ///
  /// A convenient constructor provides an easy and convenient way to create a
  /// [Shimmer] which [gradient] is [LinearGradient] made up of `baseColor` and
  /// `highlightColor`.
  ///
  static double degToRadian(double angle) {
    return (pi * angle / 180) % (2 * pi);
  }

  Shimmer.fromColors({
    super.key,
    required this.child,
    required Color baseColor,
    required Color highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.delay = Duration.zero,
    this.loop = 0,
    this.reversed = false,
    this.enabled = true,
  }) : gradient = LinearGradient(
            begin: (degToRadian(direction.val + (reversed ? 180 : 0)) >= 0 &&
                    degToRadian(direction.val + (reversed ? 180 : 0)) < pi)
                ? Alignment.centerRight
                : Alignment.centerLeft,
            end: (degToRadian(direction.val + (reversed ? 180 : 0)) >= 0 &&
                    degToRadian(direction.val + (reversed ? 180 : 0)) < pi)
                ? Alignment.centerLeft
                : Alignment.centerRight,
            colors: <Color>[
              baseColor,
              baseColor,
              highlightColor,
              baseColor,
              baseColor
            ],
            stops: const <double>[0.0, 0.15, 0.5, 0.85, 1.0],
            transform: GradientRotation(
                degToRadian(direction.val + (reversed ? 180 : 0))));

  @override
  _ShimmerState createState() => _ShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<bool>('reversed', reversed, defaultValue: false));
    properties.add(
        DiagnosticsProperty<Duration>('period', period, defaultValue: null));
    properties
        .add(DiagnosticsProperty<Duration>('delay', delay, defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: null));
    properties.add(DiagnosticsProperty<int>('loop', loop, defaultValue: 0));
  }
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 0;
  Timer? _timer;
  // var scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.period,
    )..addStatusListener((AnimationStatus status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        _count++;
        if (widget.loop <= 0 || _count < widget.loop) {
          _timer = Timer(
            widget.delay,
            () => _controller.forward(from: 0.0),
          );
        }
      });
    if (widget.enabled) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(Shimmer oldWidget) {
    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => _Shimmer(
        child: child,
        gradient: widget.gradient,
        percent: _controller.value,
        radians:
            (pi * (widget.direction.val + (widget.reversed ? 180 : 0)) / 180) %
                (2 * pi),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}

@immutable
class _Shimmer extends SingleChildRenderObjectWidget {
  final double percent;
  final Gradient gradient;
  final double radians;

  const _Shimmer(
      {Widget? child,
      required this.percent,
      required this.gradient,
      required this.radians})
      : super(child: child);

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, gradient, radians);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
    shimmer._radians = radians;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  Gradient _gradient;
  double _percent;
  double _radians;

  _ShimmerFilter(this._percent, this._gradient, this._radians);

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue;
    markNeedsPaint();
  }

  set radian(double newRadian) {
    if (newRadian == _radians) {
      return;
    }
    _radians = newRadian;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child!.size.width;
      final double height = child!.size.height;
      Rect rect;
      double dx, dy;
      if (_radians == 0 || _radians == pi) {
        dx = _offset(-width - width * tan(_radians),
            width + width * tan(_radians), _percent, _radians);
        dy = _offset((-height - height * (tan(_radians))) - 10,
            (height + height * (tan(_radians))) + 10, _percent, _radians);
        rect = Rect.fromLTWH(dx, dy, width, height);
      } else if (_radians == pi / 2 || _radians == 1.5 * pi) {
        dx = _offset((-width - width / tan(_radians)) - 10,
            (width + width / tan(_radians)) + 10, _percent, _radians);
        dy = _offset((-height - height / tan(_radians)) - 10,
            (height + height / tan(_radians)) + 10, _percent, _radians);
        rect = Rect.fromLTWH(dx, dy, width, height);
      } else {
        dy = _offset((-width - width / tan(_radians)) - 10,
            (width + width / tan(_radians)) + 10, _percent, _radians);
        dx = 0;
        rect = Rect.fromLTWH(dx, dy, width, height);
      }
      layer ??= ShaderMaskLayer();
      layer!
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent, double radians) {
    return (start + (end - start) * percent) *
        ((radians >= 0 && radians < pi) ? 1 : -1);
  }
}
