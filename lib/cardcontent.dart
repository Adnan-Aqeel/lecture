import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lecture/database.dart';
import 'package:lecture/model%20.dart';

import 'package:shared_preferences/shared_preferences.dart';

class cardcontent extends StatefulWidget {
  cardcontent(
      {Key? key,
      this.content,
      this.id,
      this.app_bar,
      this.app_barq,
      this.catID,
      this.index,
      this.title,
      this.language_typee,
      this.allpost})
      : super(key: key);
  var content;
  var title;
  var app_bar;
  var id;
  var app_barq;
  var allpost;
  var index;
  var language_typee;
  var catID;
  @override
  _cardcontentState createState() => _cardcontentState();
}

class _cardcontentState extends State<cardcontent> {
  var isBookmarked = false;
  var is_toasted = true;
  var prefs;
  var isRead;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GlassContainer(
                  height: 40,
                  width: 40,
                  blur: 8,
                  color: Colors.white.withOpacity(0.5),
                  border: Border.fromBorderSide(BorderSide.none),
                  shadowStrength: 3,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  )),
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        // color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                itemCount: widget.allpost.length,
                itemBuilder: (BuildContext, context, index) =>
                    SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ClipPath(
                            clipper: DirectionalWaveClipper(
                                horizontalPosition: HorizontalPosition.right),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                height: 200,
                                color: Colors.greenAccent,
                                child: ListTile(
                                  title: HtmlWidget(
                                    "${widget.title}",
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  // subtitle: Text("${widget.recipe_time}"),
                                  trailing: IconButton(
                                      onPressed: () {
                                        print("hello bookmark");
                                        onLikeButtonTapped();
                                      },
                                      icon: Icon(
                                        isBookmarked
                                            ? Icons.bookmark_added
                                            : Icons.bookmark_add_outlined,
                                        color: Color(0xff2c3e50),
                                        size: 30,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Divider(
                          color: Color(0xff2c3e50),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: HtmlWidget(
                          '${widget.content}',
                          buildAsync: true,
                          textStyle: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          enableCaching: true,
                          customStylesBuilder: (e) {
                            if (e.localName == 'p') {
                              return {'font-size': '18px,'};
                            }

                            if (e.localName == 'li') {
                              return {'font-size': '18px'};
                            }

                            if (e.localName == 'td') {
                              return {
                                'font-size': 'larger',
                                'border': '1px solid black'
                              };
                            }

                            if (e.localName == 'th') {
                              return {
                                'font-size': '18px',
                                'border': 'overline'
                              };
                            }
                            return null;
                          },
                          customWidgetBuilder: (e) {
                            if (e.localName != 'pre' && e.localName != 'code')
                              return null;

                            for (final child in e.children) {
                              return Column(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 20, bottom: 20),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.blue,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.code,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            " Code Example",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.content_copy,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          FlutterClipboard.copy(
                                                                  child.text)
                                                              .then((value) =>
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg:
                                                                        "Code Copied",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                  ));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: HighlightView(child.text,
                                                tabSize: 2,
                                                language:
                                                    '${widget.language_typee}',
                                                theme: draculaTheme,
                                                padding: EdgeInsets.only(
                                                    left: 12,
                                                    right: 12,
                                                    top: 16,
                                                    bottom: 16),

                                                // Specify text style
                                                textStyle: TextStyle(
                                                  fontFamily:
                                                      'My awesome monospace font',
                                                  fontSize: 16,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: false,
                  initialPage: widget.index,
                  onPageChanged: onPageChanged,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey(widget.id.toString())) {
      setState(() {
        print("Methodd Run");

        isBookmarked = true;
      });
    } else {
      setState(() {
        print("Method Loose");

        isBookmarked = false;
      });
    }
  }

  checkIfBookmarked() async {
    if (await prefs.containsKey(widget.id.toString())) {
      setState(() {
        isBookmarked = true;
      });
    } else {
      setState(() {
        isBookmarked = false;
      });
    }
  }

  checkIfRead() async {
    prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey("blog_" + widget.id.toString())) {
      print(widget.id);
      print("Failed!");
      setState(() {
        isRead = true;
      });
    } else {
      await prefs.setBool("blog_" + widget.id.toString(), true);
      print("Success");
      setState(() {
        isRead = true;
      });
    }
  }

  onLikeButtonTapped() async {
    var getBookmarkedImage = await findImage(widget.id);
    print("getBookmarkedImage $getBookmarkedImage");
    checkIfBookmarked();

    if (getBookmarkedImage == false) {
      final fido = getpostsModel(
        id: widget.id,
        title: widget.title,
        content: widget.content,
        // img: widget.contant_image,
      );

      prefs.setBool(widget.id.toString(), true);
      print(prefs.getBool(widget.id.toString()));

      print("object");

      await insertBookmark(fido);
      Flushbar(
        icon: Image.asset(
          "assets/icons.png",
          height: 30,
        ),
        title: "Added Bookmarked",
        titleColor: Color(0xff2c3e50),
        message: "added to bookmark",
        messageColor: Color(0xff2c3e50),
        backgroundColor: Color(0xffF5F5F7),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 2),
      )..show(context);

      setState(() {
        isBookmarked = true;
      });
    } else {
      await deleteCar(widget.id);
      setState(() {
        isBookmarked = false;
      });
      prefs.remove(widget.id.toString());
      print(prefs.getBool(widget.id.toString()));

      Flushbar(
        icon: Image.asset(
          "assets/icons.png",
          height: 30,
        ),
        title: "Bookmark Removed",
        titleColor: Color(0xff2c3e50),
        message: "removed from bookmark",
        messageColor: Color(0xff2c3e50),
        backgroundColor: Color(0xffF5F5F7),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 2),
      )..show(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfBookmarked();
    setPreferences();
  }

  onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      widget.content = widget.allpost[index].content;
      widget.app_bar = widget.allpost[index].title;
      widget.id = widget.allpost[index].id;
      // widget.contant_image = widget.allpost[index].jetpack_featured_media_url;
      // widget.recipe_time = widget.allpost[index].time;
    });
  }

  double _value = 5;
  my_bottom_sheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.775,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 10)
                  ]),
              child: Slider(
                value: _value,
                activeColor: Colors.white,
                inactiveColor: Colors.white,
                onChanged: (double s) {
                  setState(() {
                    _value = s;
                  });
                },
                divisions: 10,
                min: 0.0,
                max: 10.0,
              ),
            ),
            Text(
              "Hello World",
              style: TextStyle(fontSize: 10 * _value),
            ),
          ],
        ),
      ),
    );
  }
}
