import 'package:flutter/material.dart';

import '../app/theme/colours.dart';
import '../app/theme/text_style.dart';
import 'custom_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;

  const EmptyStateWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryPale,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(emoji,
                    style: const TextStyle(fontSize: 38)),
              ),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: AppTextStyles.h3,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center),
            if (buttonLabel != null && onButtonTap != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                label: buttonLabel!,
                onTap: onButtonTap,
                width: 200,
                height: 46,
              ),
            ],
          ],
        ),
      ),
    );
  }
}