class ComicItem{
  int id;
  String cover;
  String title;
  String author;
  int day;
  List<String> genres;

  ComicItem(
    this.id,
    this.cover,
    this.title,
    this.author,
    this.day,
    this.genres,
  );

  ComicItem.fromJson(Map data) {
    id = data['id'];
    cover = data['cover'];
    title = data['title'];
    author = data['author'];
    
    day = data['day'];
    genres = data['genres']?.cast<String>()?.toList();
  }
}
