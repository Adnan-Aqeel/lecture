import 'package:avatar_glow/avatar_glow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lecture/about.dart';
import 'package:lecture/bookmark.dart';
import 'package:lecture/course.dart';
import 'package:lecture/model%20.dart';
import 'package:lecture/postpage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:url_launcher/url_launcher.dart';

class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final List<String> assetImages = [
    "assets/down.jpg",
    "assets/dow.jpg",
    "assets/boo.jpg",
    "assets/downl.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xffbf00ff),
                  ),
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Color(0xffbf00ff)),
                    accountName: Text(
                      "",
                      style: TextStyle(fontSize: 18),
                    ),
                    accountEmail: Text(""),
                    currentAccountPictureSize: Size.square(50),
                    currentAccountPicture: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: AvatarGlow(
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            child: Image.asset(
                              'assets/edu.png',
                              height: 80,
                            ),
                            radius: 40.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Color(0xffbf00ff),
                  ),
                  title: const Text(
                    ' Home ',
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => homepage()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Color(0xffbf00ff),
                  ),
                  title: const Text(
                    ' BookMark ',
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Bookmark()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.bookmark,
                    color: Color(0xffbf00ff),
                  ),
                  title: const Text(
                    'About Us',
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => about()));
                  },
                ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.rate_review,
                //     color: Color(0xffbf00ff),
                //   ),
                //   title: const Text(
                //     ' Rate Us ',
                //   ),
                //   onTap: () {
                //     _launchUrl(_url);
                //   },
                // ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "More Versatality",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.feedback,
                    color: Color(0xffbf00ff),
                  ),
                  title: const Text(
                    'Logout',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.logout,
                //     color: Color(0xffbf00ff),
                //   ),
                //   title: const Text(
                //     'Share With ',
                //   ),
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => cardcontent()));
                //   },
                // ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Center(
              child: Text(
                "Learn about Biology",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Color(0xffbf00ff),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    color: Color(0xffbf00ff),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 50, bottom: 30),
                      child: Image.asset("assets/bio.png"),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => course()));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.greenAccent,
                              child: Image.asset(
                                'assets/edu.png',
                                height: 50,
                              ),
                              radius: 50.0,
                            ),
                          ),
                          SizedBox(height: 8), // Space between avatar and text
                          Text('Course List', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Bookmark()));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.amber,
                              child: Image.asset(
                                'assets/icons.png',
                                height: 50,
                              ),
                              radius: 50.0,
                            ),
                          ),
                          SizedBox(height: 8), // Space between avatar and text
                          Text('Bookmark', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => about()));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Image.asset(
                                'assets/true.png',
                                height: 50,
                              ),
                              radius: 50.0,
                            ),
                          ),
                          SizedBox(height: 8), // Space between avatar and text
                          Text('About Us', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    CarouselSlider(
                        items: assetImages.map((imagePath) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                        ))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),

                // Container(
                //   height: 50,
                //   width: 50,
                // ),
                mycat.length >= 1
                    ? GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mycat.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 230,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0),
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => page2(
                                            name: mycat[index].name,
                                            img: mycat[index].img,
                                            id: mycat[index].id,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffbf00ff),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  children: [
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Image.network(
                                        "${mycat[index].img}",
                                        height: 130,
                                      ),
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${mycat[index].name}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: LoadingAnimationWidget.inkDrop(
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          )),
    );
  }

  final Uri _url = Uri.parse('https://flutter.dev');
  _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  List<getCategorymodel> mycat = [];

  myCat() async {
    try {
      final response = await Dio().get(
          "https://pluto.infinitycodestudio.com/wp-json/wp/v2/categories?parent=6&oder=asc&per_page=100");

      var parseData =
          response.data.map((res) => getCategorymodel.fromJson(res)).toList();
      print(parseData);
      parseData.forEach((f) => {mycat.add(f)});
      setState(() {
        mycat;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myCat();
  }
}
