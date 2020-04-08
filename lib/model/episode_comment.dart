class EpisodeComment {
  String nickname;
  String avatar;
  String content;

  EpisodeComment.fromJson(Map data) {
    nickname = data['nickName'];
    avatar = data['userPhoto'];
    content = data['text'];
  }
}
