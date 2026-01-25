import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class course extends StatefulWidget {
  const course({super.key});

  @override
  State<course> createState() => _courseState();
}

class _courseState extends State<course> {
  var text = [
    "BRANCHES OF BIOLOGY",
    "ORIGIN OF LIFE ",
    "HUMAN PHYSIOLOGY  ",
    "HUMAN NEUROLOGY",
    "PLANT BIOLOGY",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffbf00ff),
        title: Text("Course List"),
      ),
      body: ListView.builder(
        itemCount: text.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: 4, // Controls the depth of the Neumorphic effect
                intensity:
                    0.8, // Controls the intensity of the shadow and highlight
                color: Colors.blue, // Background color
                lightSource:
                    LightSource.topLeft, // Direction of the light source
                shape:
                    NeumorphicShape.flat, // Shape of the Neumorphic container
                boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(12)), // Shape of the box
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12), // Adjust content padding
                leading:
                    Icon(Icons.confirmation_num_rounded, color: Colors.black),

                title: Text(
                  "${text[index]}",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
