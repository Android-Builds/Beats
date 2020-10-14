import 'package:Beats/API/saavn.dart';
import 'package:Beats/style/appColors.dart';
import 'package:Beats/ui/homepage/widgets/searchlist.dart';
import 'package:Beats/utils/constants.dart';
import 'package:Beats/utils/themes.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchBar = TextEditingController();
  bool fetchingSongs = false;
  bool searchNow = false;

  search() async {
    String searchQuery = searchBar.text;
    if (searchQuery.isEmpty) return;
    fetchingSongs = true;
    setState(() {});
    searchedList = await fetchSongsList(searchQuery);
    fetchingSongs = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            child: TextField(
              onChanged: (String value) {
                search();
              },
              controller: searchBar,
              decoration: InputDecoration(
                suffixIcon: searchedList.isEmpty
                    ? IconButton(
                        icon: fetchingSongs
                            ? SizedBox(
                                height: 18,
                                width: 18,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(accent),
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.search,
                                color: accent,
                              ),
                        color: accent,
                        onPressed: () {
                          setState(() {
                            search();
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: accent,
                        ),
                        onPressed: () {
                          setState(() {
                            searchedList.clear();
                            searchBar.clear();
                            FocusScope.of(context).unfocus();
                          });
                        }),
                hintText: "Search",
                hintStyle: TextStyle(
                  color: accent,
                ),
                contentPadding: const EdgeInsets.only(
                  left: 18,
                  right: 20,
                  top: 14,
                  bottom: 14,
                ),
              ),
            ),
          ),
          searchedList.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 15.0,
                          bottom: 5,
                        ),
                        child: Text('Top Result', style: title),
                      ),
                      SearchList(type: 'topquery'),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 15.0,
                          bottom: 5,
                        ),
                        child: Text('Songs', style: title),
                      ),
                      SearchList(type: 'songs'),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 30.0,
                          top: 15.0,
                          bottom: 5,
                        ),
                        child: Text('Albums', style: title),
                      ),
                      SearchList(type: 'albums'),
                      //SearchList(type: 'songs'),
                    ],
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
