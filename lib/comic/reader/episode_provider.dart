import 'package:pkcomics/public.dart';

class EpisodeProvider {
  static Future<Reader> fetchEpisode(int episodeId) async {
    var response = await Request.get(url: 'episode_$episodeId');
    var episode = Reader.fromJson(response);

    return episode;
  }
}
