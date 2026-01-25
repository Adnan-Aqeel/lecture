// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
// import 'package:google_fonts/google_fonts.dart';

// class page3 extends StatefulWidget {
//   var title;
//   var content;
//   page3({super.key, this.title, this.content});

//   @override
//   State<page3> createState() => _page3State();
// }

// class _page3State extends State<page3> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "${widget.title}",
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     Icon(
//                       Icons.bookmark_added_outlined,
//                       size: 40,
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   child: HtmlWidget(
//                     '${widget.content}',
//                     textStyle: GoogleFonts.poppins(
//                       fontSize: 24,
//                       trailing: IconButton(
//                           onPressed: () {
//                             print("hello bookmark");
//                             onLikeButtonTapped();
//                           },
//                           icon: Icon(
//                             isBookmarked
//                                 ? Icons.bookmark_added
//                                 : Icons.bookmark_add_outlined,
//                             color: Color(0xff2c3e50),
//                             size: 30,
//                           )),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
