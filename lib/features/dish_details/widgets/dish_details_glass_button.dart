import 'package:flutter/material.dart';

class DishDetailsGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const DishDetailsGlassButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
