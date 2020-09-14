import 'package:Musify/API/saavn.dart';
import 'package:Musify/style/appColors.dart';
import 'package:Musify/ui/albumpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeaturedPlayListWidget extends StatelessWidget {
  const FeaturedPlayListWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Text(
            'Featured PlayLists',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22,
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        FutureBuilder(
          future: getFeaturedPlaylists(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var list = snapshot.data;
              return Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      height: 200,
                      width: 200,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Hero(
                              tag: list[index].name,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  imageUrl: list[index].imageUrl,
                                ),
                              ),
                            ),
                            onTap: () {
                              print(list[index].id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumPage(
                                            image: list[index].imageUrl,
                                            tag: list[index].name,
                                          )));
                            },
                          ),
                          SizedBox(height: 10),
                          Text(
                            list[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
