import 'package:flutter/material.dart';

class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbf00ff),
        title: Text("About Us"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 80),
            child: Container(
              height: 210,
              width: 210,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/education.png"))),
            ),
          ),
          Text(
            "Designed by : Adnan Aqeel",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "University Kfueit RYK",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "Specailization : App Developer",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
