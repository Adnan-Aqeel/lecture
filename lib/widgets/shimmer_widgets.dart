import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lecture/loading_provider.dart';

class ScreenShimmerWrapper extends StatelessWidget {
  final Widget child;
  final Widget? shimmerChild;

  const ScreenShimmerWrapper({
    super.key,
    required this.child,
    this.shimmerChild,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, loadingProvider, _) {
        if (loadingProvider.showShimmer) {
          return shimmerChild ?? _defaultShimmer();
        }
        return child;
      },
    );
  }

  Widget _defaultShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(6, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _shimmerBox(40, 40, 20),
                      const SizedBox(width: 12),
                      Expanded(child: _shimmerBox(double.infinity, 16, 8)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _shimmerBox(double.infinity, 12, 6),
                  const SizedBox(height: 8),
                  _shimmerBox(180, 12, 6),
                  if (index % 2 == 0) ...[
                    const SizedBox(height: 12),
                    _shimmerBox(double.infinity, 80, 8),
                  ],
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  Widget _shimmerBox(double width, double height, double radius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class ShimmerLoader extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool showShimmer;

  const ShimmerLoader({
    super.key,
    required this.child,
    this.isLoading = false,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading || !showShimmer) return child;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerCard({
    super.key,
    required this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: double.infinity, height: 20),
            const SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 14),
            const SizedBox(height: 8),
            ShimmerBox(width: 200, height: 14),
            const SizedBox(height: 16),
            ShimmerBox(width: double.infinity, height: 100),
          ],
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int itemCount;
  final bool isLoading;

  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(itemCount, (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              ShimmerBox(width: 48, height: 48, borderRadius: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: double.infinity, height: 14),
                    const SizedBox(height: 6),
                    ShimmerBox(width: 120, height: 10),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
