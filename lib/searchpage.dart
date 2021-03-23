import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/ImagePage.dart';
import 'package:wallpaper_app/PoDO/ImageModel.dart';
import 'package:wallpaper_app/utilities/api_provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchController = TextEditingController();
  var showSearchResult = false;
  var _gridController = ScrollController();
  var hits = List<Hits>();
  int _page = 0;

  @override
  void initState() {
    _gridController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Color(0xff800020),
          elevation: 5,
          iconTheme: IconThemeData(color: Colors.grey[100]),
          title: Container(
            height: 40,
            child: TextField(
              autofocus: true,
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search Here',
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.all(8.0),
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 20.0,
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  showSearchResult = true;
                });
                _saveSuggestions(value);
                resetSearch();
                _loadSearchImages(value);
              },
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                _searchController.clear();
                resetSearch();
                showSearchResult = false;
                setState(() {});
              },
            )
          ],
        ),
        body: (showSearchResult) ? imagesGridList() : suggestionsWidget());
  }

  suggestionsWidget() {
    return FutureBuilder(
      future: _getSuggestions(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) return Container();
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.restore),
              title: Text(snapshot.data[index]),
              onTap: () {
                _searchController.text = snapshot.data[index];
                setState(() {
                  showSearchResult = true;
                });
                _saveSuggestions(snapshot.data[index]);
                resetSearch();
                _loadSearchImages(snapshot.data[index]);
              },
            );
          },
        );
      },
    );
  }

  imagesGridList() {
    return (hits.length > 0)
        ? GridView.builder(
            controller: _gridController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            itemCount: hits.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePage(
                        model: hits[index],
                        imageBoxFit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: hits[index].webformatURL,
                  fit: BoxFit.cover,
                  placeholder: (context, value) {
                    return Container(
                      height: 25,
                      width: 25,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              );
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  resetSearch() {
    hits.clear();
    _page = 0;
  }

  _loadSearchImages(String query) async {
    var model = await ApiProvider().getSearchedImages(query, ++_page);
    hits.addAll(model.hits);
    setState(() {});
  }

  _scrollListener() {
    if (_gridController.offset >= _gridController.position.maxScrollExtent &&
        !_gridController.position.outOfRange) {
      _loadSearchImages(_searchController.text);
    }
  }

  Future<List<String>> _getSuggestions() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> suggestions =
        prefs.getStringList('suggestions_list') ?? List<String>();
    return suggestions;
  }

  _saveSuggestions(String value) async {
    var prefs = await SharedPreferences.getInstance();
    List<String> suggestions =
        prefs.getStringList('suggestions_list') ?? List<String>();
    if (!suggestions.contains(value)) {
      suggestions.insert(0, value);
    } else {
      var existingIndex = suggestions.indexOf(value);
      suggestions.removeAt(existingIndex);
      suggestions.insert(0, value);
    }
    if (suggestions.length > 5) {
      suggestions.removeLast();
    }
    prefs.setStringList('suggestions_list', suggestions);
  }
}
