import 'package:pkcomics/model/comic_item.dart';

class ComicRanking {
  String updateTime;
  List<ComicItem> rankingList = [];

  ComicRanking.fromJson(Map data) {
    updateTime = data['updateTime'];
    data["rankingList"].forEach((item) {
      ComicItem comicItem = ComicItem.fromJson(item);
      rankingList.add(comicItem);
    });
  }
}