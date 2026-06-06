import 'package:flutter/material.dart';
import '../app/theme/colours.dart';

class LoadingWidget extends StatefulWidget {
  final int itemCount;
  const LoadingWidget({super.key, this.itemCount = 4});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.itemCount,
          itemBuilder: (_, __) => _buildSkeletonCard(),
        );
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _shimmer(width: 34, height: 34, radius: 99),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _shimmer(width: 120, height: 12),
              const SizedBox(height: 5),
              _shimmer(width: 70, height: 10),
            ]),
          ]),
          const SizedBox(height: 12),
          _shimmer(width: double.infinity, height: 12),
          const SizedBox(height: 6),
          _shimmer(width: double.infinity, height: 12),
          const SizedBox(height: 6),
          _shimmer(width: 180, height: 12),
          const SizedBox(height: 12),
          _shimmer(width: 90, height: 22, radius: 99),
        ],
      ),
    );
  }

  Widget _shimmer({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment(_animation.value - 1, 0),
          end: Alignment(_animation.value + 1, 0),
          colors: const [
            AppColors.surface2,
            AppColors.border,
            AppColors.surface2,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}