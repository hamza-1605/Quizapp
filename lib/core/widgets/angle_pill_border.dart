import 'package:flutter/material.dart';

// A bar with pointed ends, like an elongated hexagon.
class AnglePillBorder extends ShapeBorder {
  const AnglePillBorder({this.side = BorderSide.none, this.tip = 22});

  final BorderSide side;

  // How far the pointed ends reach into the shape.
  final double tip;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  Path _path(Rect rect) {
    final t = tip.clamp(0.0, rect.width / 2);
    final midY = rect.center.dy;
    return Path()
      ..moveTo(rect.left, midY)
      ..lineTo(rect.left + t, rect.top)
      ..lineTo(rect.right - t, rect.top)
      ..lineTo(rect.right, midY)
      ..lineTo(rect.right - t, rect.bottom)
      ..lineTo(rect.left + t, rect.bottom)
      ..close();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _path(rect.deflate(side.width));

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection})    =>  _path(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    canvas.drawPath(_path(rect.deflate(side.width / 2)), side.toPaint());
  }

  @override
  ShapeBorder scale(double t)   =>   AnglePillBorder(side: side.scale(t), tip: tip * t);
}