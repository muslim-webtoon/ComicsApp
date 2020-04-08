import 'package:pkcomics/model/comic_item.dart';

class ComicLatest {
  List<ComicItem> latestList = [];

  ComicLatest.fromJson(Map data) {
    data["latestList"].forEach((item) {
      ComicItem comicItem = ComicItem.fromJson(item);
      latestList.add(comicItem);
    });
  }
}