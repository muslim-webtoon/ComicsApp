

import 'package:pkcomics/model/comic_item.dart';

class CollectionsUtils {
  static bool isEmpty(List list) {
    if (list == null || list.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  static int size(List list) {
    //print('length ${list.length}');
    return isEmpty(list) ? 0 : list.length;
  }

  static List<ComicItem> getComicList(var list) {
    List content = list;  
    List<ComicItem> movies = [];    
    content.forEach((data) {
      movies.add(ComicItem.fromJson(data));
    });     
    return movies;
  }
}
