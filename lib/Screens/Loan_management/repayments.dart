import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/appcolor.dart';
import 'package:lecture/widgets/shimmer_widgets.dart';

class Repayments extends StatefulWidget {
  const Repayments({super.key});

  @override
  State<Repayments> createState() => _RepaymentsState();
}

class _RepaymentsState extends State<Repayments> {
  final _searchController = TextEditingController();
  String _status = 'All Statuses';
  final _metrics = const [
    _Metric('0', 'Total Repayments', Icons.receipt_long_outlined),
    _Metric('Rs 0.00', 'Total Due', Icons.attach_money),
    _Metric('Rs 0.00', 'Total Paid', Icons.payments_outlined),
    _Metric('0', 'Paid Repayments', Icons.check_circle_outline),
    _Metric('0', 'Overdue', Icons.warning_amber_outlined),
    _Metric('0', 'Pending', Icons.pending_actions_outlined),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
            elevation: 0,
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Loan Repayments',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary(context))),
              Text('Track and manage all loan repayment schedules',
                  style: TextStyle(
                      fontSize: 13, color: AppConstant.textPrimary(context)))
            ]),
            actions: [
              IconButton(
                  tooltip: 'Refresh',
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh, color: Color(0xFF0DB9D8)))
            ]),
        body: ScreenShimmerWrapper(
            child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                children: [
              _buildFilters(),
              const SizedBox(height: 16),
              _buildMetrics(),
              const SizedBox(height: 18),
              _buildEmptyState()
            ])),
      );

  Widget _buildFilters() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Search'),
        TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
                hintText: 'Search by employee/applicant name or amounts...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0DB9D8)),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear)),
                filled: true,
                fillColor: AppConstant.inputBg(context),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
        const SizedBox(height: 14),
        _label('Status'),
        DropdownButtonFormField<String>(
            value: _status,
            isExpanded: true,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                filled: true,
                fillColor: AppConstant.inputBg(context),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            items: const ['All Statuses', 'Pending', 'Paid', 'Overdue']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) => setState(() => _status = value ?? _status)),
      ]);

  Widget _buildMetrics() => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 90,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (_, index) => Card(
          elevation: 1,
          color: AppConstant.cardBg(context),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_metrics[index].value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF94A3B8),
                        )),
                    const SizedBox(height: 5),
                    Text(_metrics[index].label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ))
                  ]))));

  Widget _buildEmptyState() => Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
      decoration: BoxDecoration(
          color: AppConstant.scaffoldBg(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppConstant.border(context))),
      child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF7188A1)),
                borderRadius: BorderRadius.circular(5)),
            child: const Icon(Icons.payments_outlined,
                color: Color(0xFF7188A1), size: 28)),
        const SizedBox(height: 18),
        const Text('No repayments found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
            )),
        const SizedBox(height: 8),
        const Text('No repayments match your current filters.',
            style: TextStyle(fontSize: 12, color: Color(0xFF657C94)))
      ])));

  Widget _label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF94A3B8),
          )));
  void _refresh() => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Repayments refreshed locally.')));
}

class _Metric {
  const _Metric(this.value, this.label, this.icon);
  final String value;
  final String label;
  final IconData icon;
}
