import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'chips.i18n.dart';

class BetaChip extends StatelessWidget {
  const BetaChip({super.key, this.disabled = false});

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: !disabled
              ? Theme.of(context).colorScheme.secondary
              : AppColors.of(context).text.withValues(alpha: .25),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Center(
            child: Text(
              "beta".i18n,
              softWrap: true,
              style: TextStyle(
                fontSize: 10,
                color: disabled
                    ? AppColors.of(context).text.withValues(alpha: .5)
                    : Colors.white,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
