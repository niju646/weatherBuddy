import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:ui';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Bar Shimmer
          _buildShimmerContainer(height: 80, borderRadius: 16),

          const SizedBox(height: 24),

          // Weather Header Shimmer
          _buildShimmerContainer(height: 140, borderRadius: 24),

          const SizedBox(height: 24),

          // Calendar Shimmer
          _buildShimmerContainer(height: 120, borderRadius: 24),

          const SizedBox(height: 24),

          // Section Title Shimmer
          _buildShimmerContainer(height: 24, width: 180, borderRadius: 12),

          const SizedBox(height: 16),

          // Weather Overview Grid Shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildShimmerContainer(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildShimmerContainer(
                        height: 40,
                        width: 40,
                        borderRadius: 12,
                      ),
                      const SizedBox(height: 12),
                      _buildShimmerContainer(
                        height: 20,
                        width: 60,
                        borderRadius: 8,
                      ),
                      const SizedBox(height: 6),
                      _buildShimmerContainer(
                        height: 14,
                        width: 80,
                        borderRadius: 6,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Charts Section Title Shimmer
          _buildShimmerContainer(height: 24, width: 200, borderRadius: 12),

          const SizedBox(height: 16),

          // Charts Grid Shimmer
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
            ),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildShimmerContainer(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildShimmerContainer(
                            height: 20,
                            width: 120,
                            borderRadius: 8,
                          ),
                          _buildShimmerContainer(
                            height: 32,
                            width: 60,
                            borderRadius: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildShimmerContainer(
                          borderRadius: 12,
                          child: Center(
                            child: _buildShimmerContainer(
                              height: 80,
                              width: 80,
                              borderRadius: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    double? height,
    double? width,
    double borderRadius = 8,
    Widget? child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: child ?? _buildShimmerEffect(borderRadius),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect(double borderRadius) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.3),
      period: const Duration(milliseconds: 1500),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class ShimmerLoader extends StatelessWidget {
//   const ShimmerLoader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SingleChildScrollView(
//           child: Shimmer.fromColors(
//             baseColor: Colors.grey.shade300,
//             highlightColor: Colors.grey.shade100,
//             child: Container(
//               height: 40,
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 150,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: 5,
//             separatorBuilder: (_, __) => const SizedBox(width: 16),
//             itemBuilder: (context, index) {
//               return Shimmer.fromColors(
//                 baseColor: Colors.grey.shade300,
//                 highlightColor: Colors.grey.shade100,
//                 child: Container(
//                   width: 140,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 16),
//         ...List.generate(3, (index) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Shimmer.fromColors(
//               baseColor: Colors.grey.shade300,
//               highlightColor: Colors.grey.shade100,
//               child: Container(
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }
