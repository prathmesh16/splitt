import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GroupsDashboardShimmer extends StatelessWidget {
  const GroupsDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Colors.grey.shade300;
    final highlight = Colors.grey.shade100;
    const block = Colors.grey;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 180,
                  decoration: BoxDecoration(
                    color: block,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: block,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 6,
              itemBuilder: (_, __) => const _GroupTileShimmer(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupTileShimmer extends StatelessWidget {
  const _GroupTileShimmer();

  @override
  Widget build(BuildContext context) {
    const block = Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // left icon
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: block,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(width: 16),

              // Title + owed list
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: block,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 12,
                      width: 160,
                      decoration: BoxDecoration(
                        color: block,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // right amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(
                      color: block,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 14,
                    width: 50,
                    decoration: BoxDecoration(
                      color: block,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 12,
            width: 130,
            margin: const EdgeInsets.only(left: 80),
            decoration: BoxDecoration(
              color: block,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            width: 130,
            margin: const EdgeInsets.only(left: 80),
            decoration: BoxDecoration(
              color: block,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
