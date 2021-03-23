import 'package:flutter/material.dart';
import 'package:wallpaper_app/ImagePage.dart';
import 'package:wallpaper_app/PoDO/ImageModel.dart';
import 'package:wallpaper_app/searchpage.dart';

import 'utilities/api_provider.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  double height;
  double width;
  var hits = List<Hits>();
  int page = 0;
  bool isLoading = false;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    super.initState();
    _loadImages(page);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        page++;
        setState(() {
          isLoading = true;
        });

        _loadImages(page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff800020), //burgundy red
        elevation: 5,
        shadowColor: Color(0xff800020),
        title: GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage())),
          child: Container(
            height: 45.0,
            margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.grey[200]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                ),
                Text(
                  'Search wallpapers',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12.0),
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
              ),
              width: width,
              child: hits.length != 0
                  ? Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                controller: _sc,
                                itemCount: hits.length,
                                itemBuilder: (context, int index) {
                                  var hit;
                                  if (hits != null) {
                                    hit = hits[index];
                                  }
                                  if (hits.length == null) {
                                    return _progressbar();
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        if (hits != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ImagePage(
                                                model: hit,
                                                imageBoxFit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(15.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                              color: Colors.grey[200],
                                              width: width,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.network(
                                                  hit?.webformatURL,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                left: 0,
                                                child: Container(
                                                  height: 60.0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            hit?.user,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            hit?.tags,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                }))
                      ],
                    )
                  : Center(
                      child: Container(
                          height: 25.0,
                          width: 25.0,
                          child: CircularProgressIndicator())))
        ],
      ),
    );
  }

  _loadImages(int page) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    print(page);
    var imageModel = await ApiProvider().getImages(10, ++page);
//    hits = imageModel.hits;
    setState(() {
      hits.addAll(imageModel.hits);
    });
  }

  Widget _progressbar() {
    print('using');
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(
            backgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
