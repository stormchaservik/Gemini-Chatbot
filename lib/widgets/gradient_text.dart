import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
      this.text, {
        required this.gradient, // Gradient to apply to the text
        this.style, // Optional text style
        super.key
      });

  final String text; // Text to display
  final TextStyle? style; // Style for the text
  final Gradient gradient; // Gradient applied to the text

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn, // Apply gradient to the text's fill
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height), // Define the area for the gradient
      ),
      child: Text(text, style: style), // Apply the gradient shader to the text
    );
  }
}
