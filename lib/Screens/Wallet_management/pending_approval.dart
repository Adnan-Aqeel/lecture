import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class ApprovalQueueScreen extends StatefulWidget {
  const ApprovalQueueScreen({super.key});

  @override
  State<ApprovalQueueScreen> createState() => _ApprovalQueueScreenState();
}

class _ApprovalQueueScreenState extends State<ApprovalQueueScreen> {
  String selectedFilter = 'Pending'; // 'Pending' or 'All'

  // Replace with real data
  int pendingCount = 0;
  int totalLoaded = 0;
  List<dynamic> items = []; // your approval items list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.scaffoldBg(context),
      appBar: AppBar(
        backgroundColor: AppConstant.appBarBg(context),
       systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: Theme.of(context).brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: AppConstant.textPrimary(context)),
        titleSpacing: 0,
        title: Column(
          children: [
            Text(
              'Approval Queue',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppConstant.textPrimary(context),
              ),
            ),
            Text(
              'Review and action pending wallet transaction approvals',
              style: TextStyle(fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // TODO: refresh logic
              setState(() {});
            },
            icon: Icon(Icons.refresh, size: 18, color: AppConstant.textPrimary(context)),
            label: Text(
              'Refresh',
              style: TextStyle(color: AppConstant.textPrimary(context)),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ScreenShimmerWrapper(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle

              const SizedBox(height: 16),

              // Stat cards
              Row(
                children: [
                  Expanded(child: statCard('$pendingCount', 'PENDING')),
                  const SizedBox(width: 12),
                  Expanded(child: statCard('$totalLoaded', 'TOTAL LOADED')),
                ],
              ),
              const SizedBox(height: 16),

              // Filter chips + item count
              Row(
                children: [
                  filterChip('Pending'),
                  const SizedBox(width: 8),
                  filterChip('All'),
                  const Spacer(),
                  Text(
                    '${items.length} items',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Empty state
              if (items.isEmpty) emptyState(),
            ],
          ),
        ),
      ),
    );
  }

  // Stat card widget
  Widget statCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppConstant.textHint(context),
            ),
          ),
        ],
      ),
    );
  }

  // Filter chip widget
  Widget filterChip(String label) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2FC4D9) : AppConstant.cardBg(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppConstant.textPrimary(context),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // Empty state widget
  Widget emptyState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline, size: 55, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            'All clear!',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'There are no pending approvals right now.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
