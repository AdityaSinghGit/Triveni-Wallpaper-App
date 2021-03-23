import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:wallpaper_app/PoDO/ImageModel.dart';
import 'dart:async';
import 'package:wallpaper/wallpaper.dart';

class ImagePage extends StatefulWidget {
  final Hits model;
  final BoxFit imageBoxFit;

  ImagePage({this.model, this.imageBoxFit});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const platform =
      const MethodChannel('com.sangamsharma.wallpaper_app/wallpaper');

  String _message = "";
  String _path = "";
  String _size = "";
  String _mimeType = "";
  File _imageFile;
  // int _progress = 0;

  //TODO:wall plugin
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  Stream<String> progressString;
  String res;
  bool downloading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 55,
        backgroundColor: Colors.grey[500],
        elevation: 10,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Visibility(
            visible: true,
            child: Container(
              height: 64.0,
              padding: const EdgeInsets.only(right: 8.0),
              child: FlatButton(
                child: Text(
                  'Set as Wallpaper',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: setWallpaperDialog,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: GestureDetector(
                onTap: () {
                  if (_controller.isCompleted) {
                    _controller.reverse();
                  } else {
                    _controller.forward();
                  }
                },
                child: CachedNetworkImage(
                    imageUrl: widget.model.largeImageURL,
                    fit: widget.imageBoxFit,
                    placeholder: (context, value) {
                      return Container(
                        height: 25,
                        width: 25,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0, -_controller.value * 64),
                  ),
                  Transform.translate(
                    offset: Offset(0, _controller.value * 64),
                    child: Container(
                      height: 64.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: CircleAvatar(
                                    radius: 16.0,
                                    backgroundImage: NetworkImage(
                                        widget.model.largeImageURL),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    widget.model.type,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.share),
                                  onPressed: () {
                                    Share.share(widget.model.pageURL);
                                    print('share');
                                  },
                                ),
                                Visibility(
                                  visible: true,
                                  child: IconButton(
                                    icon: Icon(Icons.file_download),
                                    onPressed: () {
                                      _downloadImage(
                                          widget.model.largeImageURL);
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setWallpaperDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Set a wallpaper',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Home Screen',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                // onTap: () => _setWallpaper(1)
                onTap: () {
                  progressString = Wallpaper.ImageDownloadProgress(
                      widget.model.largeImageURL);
                  progressString.listen((data) {
                    setState(() {
                      res = data;
                      downloading = true;
                    });
                    print("DataReceived: " + data);
                  }, onDone: () async {
                    home = await Wallpaper.homeScreen();
                    setState(() {
                      downloading = false;
                      home = home;
                    });
                    print("Task Done");
                  }, onError: (error) {
                    setState(() {
                      downloading = false;
                    });
                    print("Some Error");
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Lock Screen',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                /*  onTap: () => _setWallpaper(2),*/
                onTap: () {
                  progressString = Wallpaper.ImageDownloadProgress(
                      widget.model.largeImageURL);
                  progressString.listen((data) {
                    setState(() {
                      res = data;
                      downloading = true;
                    });
                    print("DataReceived: " + data);
                  }, onDone: () async {
                    lock = await Wallpaper.lockScreen();
                    setState(() {
                      downloading = false;
                      lock = lock;
                    });
                    print("Task Done");
                  }, onError: (error) {
                    setState(() {
                      downloading = false;
                    });
                    print("Some Error");
                  });
                },
              ),
              ListTile(
                title: Text(
                  'Both',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Icon(
                  Icons.phone_android,
                  color: Colors.black,
                ),
                /*  onTap: () => _setWallpaper(3),*/
                onTap: () {
                  progressString = Wallpaper.ImageDownloadProgress(
                      widget.model.largeImageURL);
                  progressString.listen((data) {
                    setState(() {
                      res = data;
                      downloading = true;
                    });
                    print("DataReceived: " + data);
                  }, onDone: () async {
                    both = await Wallpaper.bothScreen();
                    setState(() {
                      downloading = false;
                      both = both;
                    });
                    print("Task Done");
                  }, onError: (error) {
                    setState(() {
                      downloading = false;
                    });
                    print("Some Error");
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _setWallpaper(int wallpaperType) async {
  //   var file =
  //       await DefaultCacheManager().getSingleFile(widget.model.largeImageURL);
  //   try {
  //     final int result = await platform
  //         .invokeMethod('setWallpaper', [file.path, wallpaperType]);
  //     print('Wallpaer Updated.... $result');
  //   } on PlatformException catch (e) {
  //     print("Failed to Set Wallpaer: '${e.message}'.");
  //   }
  //   Fluttertoast.showToast(
  //       msg: "Wallpaper set successfully",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIos: 1,
  //       backgroundColor: Colors.white,
  //       textColor: Colors.black,
  //       fontSize: 16.0);
  //   Navigator.pop(context);
  // }

  Future<void> _downloadImage(String url,
      {AndroidDestinationType destination,
      bool whenError = false,
      String outputMimeType}) async {
    String fileName;
    String path;
    int size;
    String mimeType;
    try {
      String imageId;

      if (whenError) {
        imageId = await ImageDownloader.downloadImage(url,
                outputMimeType: outputMimeType)
            .catchError((error) {
          if (error is PlatformException) {
            var path = "";
            if (error.code == "404") {
              print("Not Found Error.");
            } else if (error.code == "unsupported_file") {
              print("UnSupported FIle Error.");
              path = error.details["unsupported_file_path"];
            }
            setState(() {
              _message = error.toString();
              _path = path;
            });
          }

          print(error);
        }).timeout(Duration(seconds: 10), onTimeout: () {
          print("timeout");
          return;
        });
      } else {
        if (destination == null) {
          imageId = await ImageDownloader.downloadImage(
            url,
            outputMimeType: outputMimeType,
          );
        } else {
          imageId = await ImageDownloader.downloadImage(
            url,
            destination: destination,
            outputMimeType: outputMimeType,
          );
        }
      }

      if (imageId == null) {
        return;
      }
      fileName = await ImageDownloader.findName(imageId);
      path = await ImageDownloader.findPath(imageId);
      size = await ImageDownloader.findByteSize(imageId);
      mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      setState(() {
        _message = error.message;
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      var location = Platform.isAndroid ? "Directory" : "Photo Library";
      _message = 'Saved as "$fileName" in $location.\n';
      _size = 'size:     $size';
      _mimeType = 'mimeType: $mimeType';
      _path = path;
      print('downloaded');
      Fluttertoast.showToast(
          msg: "Downloaded successfully $_path",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 14.0);

      if (!_mimeType.contains("video")) {
        _imageFile = File(path);
      }
      return;
    });
  }
}
