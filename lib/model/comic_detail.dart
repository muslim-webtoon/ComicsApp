import 'package:pkcomics/model/episode.dart';

class ComicDetail {
  String cover;
  String title;
  String author;
  String view;
  String favorite;
  String description;
  String genre;
  List<Episode> episodeList = [];

  ComicDetail.fromJson(Map data) {
    cover = data['cover'];
    title = data['title'];
    author = data['author'];
    view = data['view'];
    favorite = data['favorite'];
    genre = data['genre'];
    description = data['description'];
    
    data["episodeList"].forEach((item) {
      Episode episode = Episode.fromJson(item);
      episodeList.add(episode);
    });
  }
}