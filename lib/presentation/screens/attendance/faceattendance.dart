import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecture/core/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecture/core/widgets/shimmer_widgets.dart';

class Faceattendance extends StatefulWidget {
  const Faceattendance({super.key});

  @override
  State<Faceattendance> createState() => _FaceattendanceState();
}

class _FaceattendanceState extends State<Faceattendance> {
  final TextEditingController datecontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        // Handle the captured image if needed
        print('Image captured: ${image.path}');
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _openGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Handle the selected image if needed
        print('Image selected: ${image.path}');
      }
    } catch (e) {
      print('Error selecting image: $e');
    }
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
          children: [
            Text(
              "Face Attendance Proofs",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary(context)),
            ),
            Text(
              "Face images captured during check-in / check-out",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppConstant.textPrimary(context)),
            ),
          ],
        ),
      ),
      body: ScreenShimmerWrapper(
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                SizedBox(
                  height: 50,
                  width: 145,
                  child: InkWell(
                    onTap: _openGallery,
                    borderRadius: BorderRadius.circular(14),
                    child: Card(
                        color: AppConstant.primarycolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.photo_library,
                              color: Colors.black,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 145,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.table_chart,
                          ),
                          Text(
                            "Table",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )),
                ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Employee"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "All Employee",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppConstant.primarycolor)),
                  ),
                  items: [
                    "Zain",
                    "Ali",
                  ].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {}),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("Month"),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: datecontroller,
                readOnly: true,
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2050),
                      initialDate: DateTime.now());
                  if (pickeddate != null) {
                    datecontroller.text =
                        "${pickeddate.month}/${pickeddate.year}";
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
                        borderSide:
                            BorderSide(color: AppConstant.primarycolor)),
                    suffixIcon: Icon(Icons.calendar_month,
                        color: AppConstant.primarycolor),
                    hintText: "mm/yyyy",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                SizedBox(
                  height: 50,
                  width: 145,
                  child: InkWell(
                    onTap: _openCamera,
                    borderRadius: BorderRadius.circular(14),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        color: Color(0xFF22d3ee),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.black,   
                            ),
                            Text(
                              "Apply",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 145,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.clear,
                          ),
                          Text(
                            "Clear",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
