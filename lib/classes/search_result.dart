import 'package:beats/api/youtube_api.dart';

class SearchResult {
  final String title;
  final String subtitle;
  final String thumbnail;

  ///browse Id for all except videos and music
  final String entityId;
  final String playlisId;
  final SearchType searchType;

  SearchResult(this.title, this.subtitle, this.thumbnail, this.entityId,
      this.playlisId, this.searchType);
}
