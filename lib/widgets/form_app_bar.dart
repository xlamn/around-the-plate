import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class FormAppBar extends StatelessWidget {
  final String? saveLabel;
  final Future<void> Function() onPressed;

  const FormAppBar({
    super.key,
    this.saveLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        IconButton(
          icon: const Icon(FIcons.x),
          onPressed: () => Navigator.of(context).pop(),
        ),
        if (saveLabel != null)
          FButton(
            onPress: onPressed,
            child: Text(saveLabel!),
          ),
      ],
    );
  }
}
