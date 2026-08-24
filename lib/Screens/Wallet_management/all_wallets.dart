import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/Screens/Wallet_management/bulk_operations.dart';
import 'package:lecture/Screens/Wallet_management/pending_approval.dart';
import 'package:lecture/Screens/Wallet_management/policies.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class WalletManagementScreen extends StatefulWidget {
  const WalletManagementScreen({super.key});

  @override
  State<WalletManagementScreen> createState() => _WalletManagementScreenState();
}

class _WalletManagementScreenState extends State<WalletManagementScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Replace with real data from your backend / state management.
  final int totalWallets = 0;
  final int activeWallets = 0;
  final int frozenWallets = 0;
  final double totalBalance = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Wallet Management',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context))),
          Text('Manage organizational, departmental, and role-based wallets',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)))
        ]),
      ),
      body: ScreenShimmerWrapper(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildStatCards(),
                const SizedBox(height: 20),
                _buildSearchAndFilters(),
                const SizedBox(height: 60),
                _buildEmptyState(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Header: title + action buttons ----------
  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;
        final titleRow = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
                _pillButton(
                  label: 'New Wallet',
                  icon: Icons.add,
                  foreground: Colors.black,
                  background: const Color(0xFF2FC4D9),
                  borderColor: const Color(0xFF2FC4D9),
                  bold: true,
                  onTap: () => _showCreateWalletDialog(),
                ),
          ],
        );

        final buttonsRow = Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _pillButton(
                  label: 'Bulk Operations',
                  icon: Icons.layers_outlined,
                  foreground: const Color(0xFFE08A1E),
                  background: AppConstant.cardBg(context),
                  borderColor: const Color(0xFFE08A1E),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BulkOperationsScreen()));
                  },
                ),
                _pillButton(
                  label: 'Expense Config',
                  icon: Icons.settings_outlined,
                  foreground: const Color(0xFFE08A1E),
                  background: AppConstant.cardBg(context),
                  borderColor: const Color(0xFFE08A1E),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BulkOperationsScreen()));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _pillButton(
                  label: 'Pending Approvals',
                  icon: Icons.hourglass_empty,
                  foreground: const Color(0xFFE08A1E),
                  background: AppConstant.cardBg(context),
                  borderColor: const Color(0xFFE08A1E),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApprovalQueueScreen()));
                  },
                ),
                _pillButton(
                  label: 'Policies',
                  icon: Icons.shield_outlined,
                  foreground: const Color(0xFFE08A1E),
                  background: AppConstant.cardBg(context),
                  borderColor: const Color(0xFFE08A1E),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApprovalPoliciesScreen()));
                  },
                ),
              ],
            )
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleRow,
              const SizedBox(height: 16),
              buttonsRow,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleRow),
            const SizedBox(width: 16),
            buttonsRow,
          ],
        );
      },
    );
  }

  Widget _pillButton({
    required String label,
    required IconData icon,
    required Color foreground,
    required Color background,
    required Color borderColor,
    required VoidCallback onTap,
    bool bold = false,
  }) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Stat cards ----------
  Widget _buildStatCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        final cards = [
          _statCard(context, '$totalWallets', 'TOTAL WALLETS', Colors.black),
          _statCard(
              context, '$activeWallets', 'ACTIVE', const Color(0xFF2ECC71)),
          _statCard(
              context, '$frozenWallets', 'FROZEN', const Color(0xFFE74C3C)),
          _statCard(context, 'Rs ${totalBalance.toStringAsFixed(0)}',
              'TOTAL BALANCE', Colors.black),
        ];

        if (isNarrow) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cards
                .map((c) => SizedBox(
                      width: (constraints.maxWidth - 12) / 2,
                      child: c,
                    ))
                .toList(),
          );
        }

        return Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }

  Widget _statCard(
      BuildContext context, String value, String label, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppConstant.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppConstant.textHint(context),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Search bar + filter chips ----------
  Widget _buildSearchAndFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        final searchField = Container(
          decoration: BoxDecoration(
            color: AppConstant.cardBg(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppConstant.border(context)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Color(0xFF9AA5B5), size: 20),
              hintText: 'Search by name or wallet number...',
              hintStyle: TextStyle(color: Color(0xFF9AA5B5), fontSize: 14),
            ),
          ),
        );

        final filterChips = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _filterChip('All'),
            const SizedBox(width: 8),
            _filterChip('Active'),
            const SizedBox(width: 8),
            _filterChip('Frozen'),
          ],
        );

        const countText = Text(
          '0 wallets',
          style: TextStyle(color: Color(0xFF8B95A5), fontSize: 13),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchField,
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: filterChips,
              ),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: countText),
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 2, child: searchField),
            const SizedBox(width: 16),
            filterChips,
            const Spacer(),
            countText,
          ],
        );
      },
    );
  }

  Widget _filterChip(String label) {
    final bool selected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color:
              selected ? const Color(0xFF2FC4D9) : AppConstant.cardBg(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFF2FC4D9)
                : AppConstant.border(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF4A5568),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ---------- Create Wallet Dialog ----------
  void _showCreateWalletDialog() {
    String? ownerType;
    final displayNameCtrl = TextEditingController();

    final ownerTypes = ['Role', 'Department', 'Branch', 'Project', 'Company'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          backgroundColor: AppConstant.cardBg(ctx),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(ctx).size.width * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2FC4D9).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.account_balance_wallet_outlined,
                            color: Color(0xFF2FC4D9), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Create New Wallet',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstant.textPrimary(ctx))),
                            const SizedBox(height: 2),
                            Text(
                                'Assign a wallet to a role, department, branch, project, or company',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppConstant.textSecondary(ctx))),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(ctx),
                        child: Icon(Icons.close,
                            size: 20, color: AppConstant.textHint(ctx)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // ── Owner Type ──
                  Row(
                    children: [
                      Text('Owner Type',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textPrimary(ctx))),
                      const SizedBox(width: 4),
                      Text('*',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.shade400)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: ownerType,
                    isDense: true,
                    decoration: InputDecoration(
                      hintText: 'Search owner type...',
                      hintStyle: TextStyle(
                          fontSize: 13, color: AppConstant.textHint(ctx)),
                      filled: true,
                      fillColor: AppConstant.inputBg(ctx),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppConstant.primarycolor, width: 1.5)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: ownerTypes
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppConstant.textPrimary(ctx))),
                            ))
                        .toList(),
                    onChanged: (v) => setDialogState(() => ownerType = v),
                  ),
                  const SizedBox(height: 18),
                  // ── Display Name ──
                  Row(
                    children: [
                      Text('Display Name',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.textPrimary(ctx))),
                      const SizedBox(width: 4),
                      Text('*',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.shade400)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: displayNameCtrl,
                    style: TextStyle(
                        fontSize: 13, color: AppConstant.textPrimary(ctx)),
                    decoration: InputDecoration(
                      hintText: 'e.g. Finance Department Wallet',
                      hintStyle: TextStyle(
                          fontSize: 13, color: AppConstant.textHint(ctx)),
                      filled: true,
                      fillColor: AppConstant.inputBg(ctx),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: AppConstant.border(ctx))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppConstant.primarycolor, width: 1.5)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                      'Auto-filled — edit to customise how this wallet appears across the system.',
                      style: TextStyle(
                          fontSize: 11, color: AppConstant.textHint(ctx))),
                  const SizedBox(height: 24),
                  // ── Buttons ──
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstant.textSecondary(ctx),
                            side: BorderSide(color: AppConstant.border(ctx)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (ownerType == null ||
                                displayNameCtrl.text.trim().isEmpty) return;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Wallet "${displayNameCtrl.text.trim()}" created successfully'),
                                backgroundColor: const Color(0xFF2FC4D9),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Create Wallet'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2FC4D9),
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Empty state ----------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 56,
            color: Color(0xFFB9C2CF),
          ),
          const SizedBox(height: 16),
          Text(
            'No wallets yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppConstant.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create the first wallet to get started.',
            style:
                TextStyle(fontSize: 13, color: AppConstant.textHint(context)),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () => _showCreateWalletDialog(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Wallet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2FC4D9),
              foregroundColor: Colors.black87,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
