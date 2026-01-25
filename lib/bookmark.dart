import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lecture/cardcontent.dart';
import 'package:lecture/database.dart';
import 'package:lecture/model%20.dart';

class Bookmark extends StatefulWidget {
  Bookmark({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookmarkState();
  }
}

class BookmarkState extends State<Bookmark> {
  ScrollController _scrollController = new ScrollController();
  var pageCount = 1;
  var connectivityResult;
  static List<getpostsModel> allpost = [];

  fetchPost() async {
    try {
      allpost = await getBookmark();
      print(allpost);
      setState(() {
        allpost;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    fetchPost();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    pageCount = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 10) / 2.3;
    final double itemWidth = size.width / 2;

    showLoadingOrList() {
      if (allpost.length >= 1) {
        return postsGridViewBuilder(
          scrollController: _scrollController,
          allpost: allpost,
          // dark: widget.pass_dark,
          // showAppBar: widget.showAppBar,
//            pageCount: pageCount,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(
            top: 200,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset('assets/icons.png', height: 180),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                      child: Text(
                    "No Bookmark found",
                    style: GoogleFonts.varelaRound(
                        fontSize: 18,
                        // color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ],
            ),
          ),
        );
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   leading: InkWell(
        //       onTap: () {
        //         Navigator.of(context).pop();
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: GlassContainer(
        //             height: 40,
        //             width: 40,
        //             blur: 8,
        //             color: Colors.white.withOpacity(0.5),
        //             border: Border.fromBorderSide(BorderSide.none),
        //             shadowStrength: 5,
        //             shape: BoxShape.rectangle,
        //             borderRadius: BorderRadius.circular(16),
        //             shadowColor: Colors.black.withOpacity(0.2),
        //             child: Icon(
        //               Icons.arrow_back_ios_new,
        //               color: widget.pass_dark ? Colors.white : Colors.black,
        //             )),
        //       )),
        //   backgroundColor: Colors.transparent,
        // ),

        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    showLoadingOrList(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class postsGridViewBuilder extends StatelessWidget {
  postsGridViewBuilder({
    Key? key,
    required ScrollController scrollController,
    required this.allpost,

//    @required this.pageCount,
    this.itemWidth,
    this.itemHeight,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;
  List<getpostsModel> allpost;
  var itemWidth;
  var itemHeight;

//  int pageCoun

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 140;
    var _aspectRatio = _width / cellHeight;

    var _crossAxisSpacingq = 8;
    var _screenWidthq = MediaQuery.of(context).size.width;
    var _crossAxisCountq = 1;
    var _widthq =
        (_screenWidthq - ((_crossAxisCountq - 1) * _crossAxisSpacingq)) /
            _crossAxisCountq;
    var cellHeightq = 120;
    var _aspectRatioq = _widthq / cellHeightq;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 0),
          child: ListTile(
            leading: Image.asset(
              "assets/book.png",
              height: 40,
            ),
            title: Text(
              "Bookmark Lectures:",
              style: TextStyle(),
            ),
            // subtitle: Text(
            //   "Want to invest your money and don't know where to start? Read on for our top tutorials.",
            //   style:
            //       GoogleFonts.varelaRound(textStyle: TextStyle()),
            // ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Divider(),
        ),
        GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: allpost.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: _aspectRatioq,
                mainAxisSpacing: 5,
                crossAxisSpacing: 0),
            itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => cardcontent(
                            content: allpost[index].content,
                            title: allpost[index].title,
                            // app_barq: widget.title,
                            allpost: allpost,
                            index: index,
                            // catID: widget.ids,
                            // recipe_time: "Favourite recipe",
                            id: allpost[index].id,
                            // dark_mode_pass: dark,
                            // contant_image: allpost[index].img,
                          ),
                        ));
                  },
                  child: Hero(
                    tag: "${allpost[index].img}",
                    child: Container(
                      // height: 120,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 10, bottom: 10),
                        child: Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(12)),
                              depth: 6,
                              shadowLightColor: Colors.black.withOpacity(0.4),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    "assets/educa.png",
                                    height: 50,
                                  ),
                                ),
                                Expanded(
                                    child: AutoSizeText(
                                  "${allpost[index].title}",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  )),
                                  maxLines: 3,
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    // color: Colors.red,
                                    child: Image.asset("assets/false.png"),
                                    height: 30,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ))),
      ],
    );
  }
}
