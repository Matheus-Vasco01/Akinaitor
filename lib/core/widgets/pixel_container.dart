import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PixelContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final String? tagText;
  final Color? tagBackgroundColor;
  final Color? tagTextColor;
  final Color? shadowColor;
  final Offset shadowOffset;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const PixelContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 4.0,
    this.tagText,
    this.tagBackgroundColor,
    this.tagTextColor,
    this.shadowColor,
    this.shadowOffset = const Offset(0, 0),
    this.padding = const EdgeInsets.all(16.0),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget containerContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: shadowColor != null && shadowOffset != Offset.zero
            ? [
                BoxShadow(
                  color: shadowColor!,
                  offset: shadowOffset,
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (tagText == null) {
      return containerContent;
    }

    // If tagText is present, stack it with a tag on top of the border
    final resolvedTagBg = tagBackgroundColor ?? borderColor;
    final resolvedTagTextCol = tagTextColor ?? Colors.white;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        containerContent,
        Positioned(
          top: -12.0, // Adjust so it sits nicely centered on the top border
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: resolvedTagBg,
                border: Border.all(
                  color: borderColor,
                  width: 2.0,
                ),
              ),
              child: Text(
                tagText!.toUpperCase(),
                style: GoogleFonts.pressStart2p(
                  color: resolvedTagTextCol,
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
