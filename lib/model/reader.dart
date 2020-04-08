class Reader {
  int id;
  String title;
  int nextEpisodeId;
  int preEpisodeId;
  int index;
  List<String> comicPictureList = [];

  Reader.fromJson(Map data) {
    id = data['id'];
    title = data['title'];
    index = data['index'];
    nextEpisodeId = data['next_id'];
    preEpisodeId = data['prev_id'];
    data["comicPictureList"].forEach((piece) {
      comicPictureList.add(piece);
    });
  }

}