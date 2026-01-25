import 'package:dio/dio.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:lecture/cardcontent.dart';
import 'package:lecture/model%20.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class page2 extends StatefulWidget {
  var name;
  var img;
  var id;
  page2({super.key, this.name, this.img, this.id});

  @override
  State<page2> createState() => _page2State();
}

class _page2State extends State<page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Learn about Biology "),
        backgroundColor: Color(0xffbf00ff),
      ),
      body: allpost.length >= 1
          ? ListView.builder(
              itemCount: allpost.length,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 4, // Controls the depth of the Neumorphic effect
                      intensity:
                          0.8, // Controls the intensity of the shadow and highlight
                      color: Colors.blue, // Background color
                      lightSource:
                          LightSource.topLeft, // Direction of the light source
                      shape: NeumorphicShape
                          .flat, // Shape of the Neumorphic container
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)), // Shape of the box
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => cardcontent(
                              title: allpost[index].title,
                              content: allpost[index].content,
                              allpost: allpost,
                              index: index,
                              catID: widget.id,
                              id: allpost[index].id,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.all(12), // Adjust content padding
                        leading: Icon(Icons.confirmation_num_rounded,
                            color: Colors.black),
                        trailing:
                            Icon(Icons.arrow_circle_right, color: Colors.black),
                        title: Text(
                          "${allpost[index].title}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ),
    );
  }

  List<getpostsModel> allpost = [];

  getposts() async {
    try {
      final response = await Dio().get(
          "https://pluto.infinitycodestudio.com/wp-json/wp/v2/posts?categories=${widget.id}&order=asc&per_page=100");
      var parseData =
          response.data.map((res) => getpostsModel.fromJson(res)).toList();
      print(parseData);
      parseData.forEach((f) => {allpost.add(f)});
      setState(() {
        allpost;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getposts();
  }
}
