import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool circular;

  const GlassButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: circular ? .circle : .rectangle,
          borderRadius: circular ? null : .circular(AppSizes.radiusM),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
