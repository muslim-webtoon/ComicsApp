import 'package:pkcomics/model/comic_item.dart';

class ComicWeekly {
  List<ComicItem> weeklyList = [];

  ComicWeekly.fromJson(Map data) {
    data["weeklyList"].forEach((item) {
      ComicItem comicItem = ComicItem.fromJson(item);
      weeklyList.add(comicItem);
    });
  }
}
