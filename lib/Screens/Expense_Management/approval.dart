import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class PendingApproval {
  final int id;
  final String title;
  final String requestedBy;
  final double amount;
  final String date;
  final String status;
  bool isSelected;

  PendingApproval({
    required this.id,
    required this.title,
    required this.requestedBy,
    required this.amount,
    required this.date,
    required this.status,
    this.isSelected = false,
  });
}

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final List<PendingApproval> _approvals = [];
  bool _selectAll = false;

  int get _selectedCount => _approvals.where((a) => a.isSelected).length;

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Pending Approvals',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.textPrimary(context)),
              ),
              Text(
                'Expense requests awaiting your action',
                style: TextStyle(
                    fontSize: 13, color: AppConstant.textPrimary(context)),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Action Performed!'))); },
                icon: const Icon(Icons.refresh, color: Colors.white, size: 22),
                tooltip: 'Refresh',
              ),
            ),
          ],
        ),
        body: ScreenShimmerWrapper(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton.icon(
                  onPressed: _selectedCount > 0 ? _bulkAction : null,
                  icon: Icon(Icons.done_all, size: 16),
                  label: Text('Bulk Approve/Reject ($_selectedCount)',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF66BB6A))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCount > 0
                        ? const Color(0xFF66BB6A)
                        : AppConstant.primarycolor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                  ),
                ),
              SizedBox(
                height: 200,
              ),
              _approvals.isEmpty ? _buildEmptyState() : _buildApprovalList(),
            ],
          ),
        ));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppConstant.textSecondary(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.check_circle_outline,
                size: 56, color: AppConstant.textHint(context)),
          ),
          const SizedBox(height: 20),
          Text(
            'No Pending Approvals',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstant.textSecondary(context)),
          ),
          const SizedBox(height: 8),
          Text(
            'All requests assigned to you have been processed.',
            style:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppConstant.cardBg(context),
          child: Row(
            children: [
              Checkbox(
                value: _selectAll,
                onChanged: (val) {
                  setState(() {
                    _selectAll = val ?? false;
                    for (var approval in _approvals) {
                      approval.isSelected = _selectAll;
                    }
                  });
                },
                activeColor: AppConstant.primarycolor,
              ),
              Text(
                'Select All (${_approvals.length})',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              if (_selectedCount > 0)
                Text(
                  '$_selectedCount selected',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppConstant.primarycolor,
                      fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _approvals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildApprovalCard(_approvals[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalCard(PendingApproval approval) {
    return GestureDetector(
      onTap: () {
        setState(() {
          approval.isSelected = !approval.isSelected;
          _selectAll = _approvals.every((a) => a.isSelected);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstant.cardBg(context),
          borderRadius: BorderRadius.circular(12),
          border: approval.isSelected
              ? Border.all(color: AppConstant.primarycolor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Checkbox(
              value: approval.isSelected,
              onChanged: (val) {
                setState(() {
                  approval.isSelected = val ?? false;
                  _selectAll = _approvals.every((a) => a.isSelected);
                });
              },
              activeColor: AppConstant.primarycolor,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    approval.title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Requested by: ${approval.requestedBy}',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppConstant.textSecondary(context)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Date: ${approval.date}',
                    style: TextStyle(
                        fontSize: 11, color: AppConstant.textHint(context)),
                  ),
                ],
              ),
            ),
            Text(
              'Rs ${approval.amount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            _actionButton(
              icon: Icons.check_circle_outline,
              color: Colors.green,
              onTap: () => _approveRequest(approval),
            ),
            _actionButton(
              icon: Icons.cancel_outlined,
              color: Colors.red,
              onTap: () => _rejectRequest(approval),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  void _approveRequest(PendingApproval approval) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: const Text('Approve Request'),
        content: Text('Are you sure you want to approve "${approval.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(
                  () => _approvals.removeWhere((a) => a.id == approval.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${approval.title}" approved'),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectRequest(PendingApproval approval) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: const Text('Reject Request'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to reject "${approval.title}"?'),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Reason for rejection',
                  hintText: 'Enter reason',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(
                  () => _approvals.removeWhere((a) => a.id == approval.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${approval.title}" rejected'),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _bulkAction() {
    if (_selectedCount == 0) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppConstant.cardBg(context),
        title: const Text('Bulk Action'),
        content: Text(
            'What would you like to do with $_selectedCount selected items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppConstant.textSecondary(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _approvals.removeWhere((a) => a.isSelected);
                _selectAll = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Selected items approved'),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Approve All'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _approvals.removeWhere((a) => a.isSelected);
                _selectAll = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Selected items rejected'),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Reject All'),
          ),
        ],
      ),
    );
  }
}
