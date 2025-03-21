import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class CardHandle extends StatelessWidget {
  const CardHandle({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42.0,
          height: 4.0,
          margin: const EdgeInsets.only(top: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45.0),
            color: AppColors.of(context).text.withValues(alpha: 0.10),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
