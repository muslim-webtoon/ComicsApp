class Episode {
  int id;
  String imgurl;
  String episode;
  String date;
  int index;

  Episode.fromJson(Map data) {
    id = data["id"];
    imgurl = data['imgurl'];
    episode = data['episode'];
    date = data['date'];
    index = data['index'];
  }
}
