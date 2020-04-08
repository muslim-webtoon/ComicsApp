import 'package:pkcomics/model/comic_item.dart';

class ComicGenre {
  List<ComicItem> genreList = [];

  ComicGenre.fromJson(Map data) {
    data["genreList"].forEach((item) {
      ComicItem comicItem = ComicItem.fromJson(item);
      genreList.add(comicItem);
    });
  }
}
