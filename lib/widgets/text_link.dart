import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? color;
  final Color? hoverColor;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextDecoration? decoration;

  const TextLink({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.hoverColor,
    this.textStyle,
    this.textAlign,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: color ?? const Color(0xFFfa3333),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: decoration ?? TextDecoration.underline,
                  decorationColor: color ?? const Color(0xFFfa3333),
                ),
            textAlign: textAlign,
          ),
        ),
      ),
    );
  }
}
