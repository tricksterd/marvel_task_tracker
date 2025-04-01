import 'package:flutter/material.dart';
import '../../application/core/styles.dart';

class AlertBanner extends StatefulWidget {
  const AlertBanner({
    super.key,
  });

  @override
  State<AlertBanner> createState() => _AlertBannerState();
}

class _AlertBannerState extends State<AlertBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ))
      ..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.redAccent,
      end: Colors.red[900],
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: _colorAnimation.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.warning, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Avengers Emergency Alert: \nNick Fury is calling!',
                    style: AppTextStyle.primaryText.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
