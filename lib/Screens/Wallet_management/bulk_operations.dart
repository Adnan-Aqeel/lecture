import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class BulkOperationsScreen extends StatefulWidget {
  const BulkOperationsScreen({super.key});

  @override
  State<BulkOperationsScreen> createState() => _BulkOperationsScreenState();
}

class WalletRow {
  String? wallet;
  double amount;
  String remarks;

  WalletRow({this.wallet, this.amount = 0, this.remarks = ''});
}

class _BulkOperationsScreenState extends State<BulkOperationsScreen> {
  String transactionType = 'Credit'; // Credit, Debit, Transfer
  final categoryController = TextEditingController(text: 'Budget Allocation');
  final remarksController = TextEditingController();

  List<WalletRow> rows = [WalletRow()];

  double get total => rows.fold(0, (sum, r) => sum + r.amount);

  void addRow() {
    setState(() => rows.add(WalletRow()));
  }

  void removeRow(int index) {
    setState(() => rows.removeAt(index));
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
        elevation: 0.5,
        iconTheme: IconThemeData(color: AppConstant.textPrimary(context)),
        titleSpacing: 0,
        title: Column(
          children: [
            Text(
              'Bulk Operations',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppConstant.textPrimary(context),
              ),
            ),
            Text(
              'Apply a single transaction type across multiple wallets simultaneously',
              style: TextStyle(
                  fontSize: 13, color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Step indicator
              stepIndicator(),
              const SizedBox(height: 20),

              // Form card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstant.cardBg(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRANSACTION SETTINGS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textHint(context),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Transaction type
                    const Text(
                      'Transaction Type *',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        typeButton('Credit'),
                        const SizedBox(width: 8),
                        typeButton('Debit'),
                        const SizedBox(width: 8),
                        typeButton('Transfer'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Category
                    const Text(
                      'Category *',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: categoryController,
                      decoration: inputDecoration(''),
                    ),
                    const SizedBox(height: 16),

                    // Global remarks
                    const Text(
                      'Global Remarks *',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: remarksController,
                      decoration: inputDecoration(
                          'Describe the purpose of this bulk operation...'),
                    ),
                    const SizedBox(height: 24),

                    // Wallet rows header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'WALLET ROWS (${rows.length})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppConstant.textHint(context),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: addRow,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Row'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2FC4D9),
                            side: const BorderSide(color: Color(0xFF2FC4D9)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Rows list
                    Column(
                      children: List.generate(rows.length, (index) {
                        return walletRowItem(index);
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Total + Preview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'Total: ',
                            style: TextStyle(
                                color: AppConstant.textPrimary(context)),
                            children: [
                              TextSpan(
                                text: 'Rs ${total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' across ${rows.length} wallet'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: go to Preview step
                        },
                        icon:
                            const Icon(Icons.remove_red_eye_outlined, size: 18),
                        label: const Text('Preview'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2FC4D9),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step indicator: Configure -> Preview -> Result
  Widget stepIndicator() {
    return Row(
      children: [
        stepCircle('1', 'Configure', active: true),
        stepLine(),
        stepCircle('2', 'Preview', active: false),
        stepLine(),
        stepCircle('3', 'Result', active: false),
      ],
    );
  }

  Widget stepCircle(String number, String label, {required bool active}) {
    final color = active ? const Color(0xFF2FC4D9) : Colors.grey;
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: AppConstant.cardBg(context),
          child: Text(
            number,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget stepLine() {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppConstant.border(context),
      ),
    );
  }

  // Transaction type button (Credit/Debit/Transfer)
  Widget typeButton(String label) {
    bool isSelected = transactionType == label;
    Color color = label == 'Credit'
        ? Colors.green
        : label == 'Debit'
            ? Colors.red
            : Colors.blue;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => transactionType = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? color : AppConstant.border(context),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? color.withValues(alpha: 0.08)
                : AppConstant.cardBg(context),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? color : AppConstant.textPrimary(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppConstant.textHint(context)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppConstant.border(context)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  // Single wallet row (wallet dropdown / amount / remarks / delete)
  Widget walletRowItem(int index) {
    final row = rows[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Wallet select
          Expanded(
            flex: 14,
            child: DropdownButtonFormField<String>(
              value: row.wallet,
              hint: Column(
                children: [
                  Text('Select wallet..'),
                ],
              ),
              decoration: inputDecoration(''),
              items: const [
                DropdownMenuItem(value: 'Wallet A', child: Text('Wallet A')),
                DropdownMenuItem(value: 'Wallet B', child: Text('Wallet B')),
              ],
              onChanged: (value) => setState(() => row.wallet = value),
            ),
          ),
          const SizedBox(width: 8),
          // Amount
          Expanded(
            flex: 6,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: inputDecoration('0'),
              onChanged: (value) {
                setState(() => row.amount = double.tryParse(value) ?? 0);
              },
            ),
          ),
          const SizedBox(width: 8),
          // Row remarks

          IconButton(
            icon: Icon(Icons.delete_outline,
                color: AppConstant.textHint(context)),
            onPressed: rows.length > 1 ? () => removeRow(index) : null,
          ),
        ],
      ),
    );
  }
}
