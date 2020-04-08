class UpdateToday {
  int id;
  String cover;
  String title;
  String author;

  UpdateToday.fromJson(Map data) {
    id = data['id'];
    cover = data['cover'];
    title = data['title'];
    author = data['author'];
  }
}
