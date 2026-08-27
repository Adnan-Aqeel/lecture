import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:lecture/data/models/base_models.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class Publiccalender extends StatefulWidget {
  const Publiccalender({super.key});

  @override
  State<Publiccalender> createState() => _PubliccalenderState();
}

class _PubliccalenderState extends State<Publiccalender> {
  List<HolidayModel> holidays = [];

  final TextEditingController datecontroller = TextEditingController();
  final TextEditingController tocontroller = TextEditingController();
  final TextEditingController holidaycontroller = TextEditingController();

  final ScrollController horizontalcontroller = ScrollController();
  final ScrollController verticalcontroller = ScrollController();

  @override
  void dispose() {
    datecontroller.dispose();
    tocontroller.dispose();
    holidaycontroller.dispose();
    horizontalcontroller.dispose();
    verticalcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Public Holidays",
              style: TextStyle(color: AppConstant.textPrimary(context)),
            ),
            Text(
              "Configure public holidays for attendance",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 48,
                  width: 170,
                  child: Material(
                    color: AppConstant.primarycolor,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 150));
                        if (datecontroller.text.isEmpty ||
                            tocontroller.text.isEmpty ||
                            holidaycontroller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Fill out the required Data"),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          holidays.add(
                            HolidayModel(
                              fromDate: datecontroller.text,
                              toDate: tocontroller.text,
                              holidayName: holidaycontroller.text,
                            ),
                          );
                          datecontroller.clear();
                          tocontroller.clear();
                          holidaycontroller.clear();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.add, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Save Holiday",
                            style: TextStyle(
                        color: AppConstant.textPrimary(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // 1. From Date Field
              const Text(
                "From Date",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: datecontroller,
                readOnly: true,
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2026),
                    lastDate: DateTime(2050),
                    initialDate: DateTime.now(),
                  );
                  if (pickeddate != null) {
                    datecontroller.text =
                        "${pickeddate.day}/${pickeddate.month}/${pickeddate.year}";
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppConstant.primarycolor),
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: AppConstant.primarycolor,
                  ),
                  hintText: "dd/mm/yyyy",
                ),
              ),
              const SizedBox(height: 20),

              // 2. To Date Field
              const Text(
                "To Date",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: tocontroller,
                readOnly: true,
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2026),
                    lastDate: DateTime(2050),
                    initialDate: DateTime.now(),
                  );
                  if (pickeddate != null) {
                    tocontroller.text =
                        "${pickeddate.day}/${pickeddate.month}/${pickeddate.year}";
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppConstant.primarycolor),
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: AppConstant.primarycolor,
                  ),
                  hintText: "dd/mm/yyyy",
                ),
              ),
              const SizedBox(height: 20),

              // 3. Holiday Name Field
              const Text(
                "Holiday Name",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: holidaycontroller,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppConstant.primarycolor),
                  ),
                  hintText: "e.g. Public Holiday",
                ),
              ),
              const SizedBox(height: 20),

              // 4. Save Holiday Button

              const SizedBox(height: 24),

              // 5. Holidays Data Table
              Container(
                decoration: BoxDecoration(
                  color: AppConstant.cardBg(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppConstant.border(context)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 900),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          AppConstant.primarycolor,
                        ),
                        columns: [
                          DataColumn(
                            label: Row(
                              children: [
                                Icon(Icons.numbers,
                                    size: 18, color: Colors.black),
                                SizedBox(width: 6),
                                Text(
                                  "#",
                                  style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Icon(Icons.calendar_month,
                                    size: 18, color: Colors.black),
                                SizedBox(width: 6),
                                Text(
                                  "FROM DATE",
                                  style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Icon(Icons.event,
                                    size: 18, color: Colors.black),
                                SizedBox(width: 6),
                                Text(
                                  "TO DATE",
                                  style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Icon(Icons.label_outline,
                                    size: 18, color: Colors.black),
                                SizedBox(width: 6),
                                Text(
                                  "HOLIDAY",
                                  style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          DataColumn(
                            label: Row(
                              children: [
                                Icon(Icons.settings,
                                    size: 18, color: Colors.black),
                                SizedBox(width: 6),
                                Text(
                                  "ACTION",
                                  style: TextStyle(
                          color: AppConstant.textPrimary(context),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                        rows: List.generate(holidays.length, (index) {
                          final holiday = holidays[index];
                          return DataRow(
                            cells: [
                              DataCell(Text("${index + 1}")),
                              DataCell(Text(holiday.fromDate)),
                              DataCell(Text(holiday.toDate)),
                              DataCell(Text(holiday.holidayName)),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      holidays.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
